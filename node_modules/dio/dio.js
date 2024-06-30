(function(name, definition) {

    if (typeof define === 'function') { // RequireJS
        define(function() { return definition; });
    } else if (typeof module !== 'undefined' && module.exports) { // CommonJS
        module.exports = definition;
    } else { // Browser
        this[name] = definition;
    }

})('dio', function(root) {
    /**
     * DIO
     *
     * Originally from:
     * https://github.com/wilsonpage/fastdom
     *
     * Eliminates layout thrashing
     * by batching DOM read/write
     * interactions.
     *
     * - Prefix private api methods with "_"
     * - Remove cancelAnimationFrame as it's not used
     * - Reduced repeat assignments to the prototype to reduce file size
     * - Made uniqueId truely private
     * - Made "mode" an int comparison
     * - Removed context passing
     * - Pulled out the frame run and binded it to this
     * - Abstract out function checks
     * - Removed try catching
     * - Remove requestAnimationFrame prefix checking
     */

    var raf = root.requestAnimationFrame ||
        function(cb) { return root.setTimeout(cb, 1000 / 60); },

        // Id generator
        _uniqueId = (function() {
            var id = 0;
            return function() {
                return ++id;
            };
        }()),

        _isFunction = function(val) {
            return (typeof val === 'function');
        },

        _MODE_NONE = 0,
        _MODE_READ = 1,
        _MODE_WRITE = 2;

    /**
     * Creates a fresh
     * DIO instance.
     *
     * @constructor
     */
    var DIO = function() {
        this.frames = [];

        this.batch = {
            hash:  {},
            read:  [],
            write: [],
            mode:  _MODE_NONE
        };

        // Cheaper to do this once...
        this._runFrame = this._runFrame.bind(this);
    };

    DIO.prototype = {
        /**
         * Adds a job to the
         * read batch and schedules
         * a new frame if need be.
         *
         * @param  {Function} fn
         * @api public
         */
        read: function(fn) {
            var job = this._add('read', fn),
                id = job.id;

            // Add this job to the read queue
            this.batch.read.push(job.id);

            // We should *not* _schedule a new frame if:
            // 1. We're 'reading'
            // 2. A frame is already scheduled
            var doesntNeedFrame = this.batch.mode === _MODE_READ || this.batch.scheduled;

            // If a frame isn't needed, return
            if (doesntNeedFrame) { return id; }

            // Schedule a new
            // frame, then return
            this._scheduleBatch();
            return id;
        },

        /**
         * Adds a job to the
         * write batch and schedules
         * a new frame if need be.
         *
         * @param  {Function} fn
         * @api public
         */
        write: function(fn) {
            var job = this._add('write', fn),
                mode = this.batch.mode,
                id = job.id;

            // Push the job id into the queue
            this.batch.write.push(job.id);

            // We should *not* _schedule a new frame if:
            // 1. We are 'writing'
            // 2. We are 'reading'
            // 3. A frame is already scheduled.
            var doesntNeedFrame = mode === _MODE_WRITE ||
                mode === _MODE_READ ||
                this.batch.scheduled;

            // If a frame isn't needed, return
            if (doesntNeedFrame) { return id; }

            // Schedule a new
            // frame, then return
            this._scheduleBatch();
            return id;
        },

        /**
         * Defers the given job
         * by the number of frames
         * specified.
         *
         * If no frames are given
         * then the job is run in
         * the next free frame.
         *
         * @param  {Number}   frame
         * @param  {Function} fn
         * @api public
         */
        defer: function(frame, fn) {

            // Accepts two arguments
            if (_isFunction(frame)) {
                fn = frame;
                frame = 1;
            }

            var self = this;
            var index = frame - 1;

            return this._schedule(index, function() {
                self._run({
                    fn: fn
                });
            });
        },

        /**
         * Clears a scheduled 'read',
         * 'write' or 'defer' job.
         *
         * @param  {Number} id
         * @api public
         */
        clear: function(id) {

            // Defer jobs are cleared differently
            if (_isFunction(id)) {
                return this._clearFrame(id);
            }

            var job = this.batch.hash[id];
            if (!job) { return; }

            var list = this.batch[job.type],
                index = list.indexOf(id);

            // Clear references
            delete this.batch.hash[id];

            if (~index) { list.splice(index, 1); }
        },

        /**
         * Clears a scheduled frame.
         *
         * @param  {Function} frame
         * @api private
         */
        _clearFrame: function(frame) {
            var index = this.frames.indexOf(frame);
            if (~index) { this.frames.splice(index, 1); }
        },

        /**
         * Schedules a new read/write
         * batch if one isn't pending.
         *
         * @api private
         */
        _scheduleBatch: function() {
            var self = this;

            // Schedule batch for next frame
            this._schedule(0, function() {
                self.batch.scheduled = false;
                self._runBatch();
            });

            // Set flag to indicate
            // a frame has been scheduled
            this.batch.scheduled = true;
        },

        /**
         * Calls each job in
         * the list passed.
         *
         * If a context has been
         * stored on the function
         * then it is used, else the
         * current `this` is used.
         *
         * @param  {Array} list
         * @api private
         */
        _flush: function(list) {
            var id;
            while ((id = list.shift())) {
                this._run(this.batch.hash[id]);
            }
        },

        /**
         * Runs any 'read' jobs followed
         * by any 'write' jobs.
         *
         * We run this inside a try catch
         * so that if any jobs error, we
         * are able to recover and continue
         * to _flush the batch until it's empty.
         *
         * @api private
         */
        _runBatch: function() {
            // Set the mode to 'reading',
            // then empty all read jobs
            this.batch.mode = _MODE_READ;
            this._flush(this.batch.read);

            // Set the mode to 'writing'
            // then empty all write jobs
            this.batch.mode = _MODE_WRITE;
            this._flush(this.batch.write);

            this.batch.mode = _MODE_NONE;
        },

        /**
         * Adds a new job to
         * the given batch.
         *
         * @param {Array}   list
         * @param {Function} fn
         * @returns {Number} id
         * @api private
         */
        _add: function(type, fn) {
            var id = _uniqueId();
            return (this.batch.hash[id] = {
                id: id,
                fn: fn,
                type: type
            });
        },

        /**
         * Runs a given job.
         *
         * @param  {Object} job
         * @api private
         */
        _run: function(job) {
            var fn = job.fn;

            // Clear reference to the job
            delete this.batch.hash[job.id];

            fn();
        },

        /**
         * Starts a rAF loop
         * to empty the frame queue.
         *
         * @api private
         */
        _loop: function() {
            var self = this;

            // Don't start more than one loop
            if (this._isLooping) { return; }

            raf(this._runFrame);

            this._isLooping = true;
        },

        _runFrame: function() {
            var self = this,
                fn = self.frames.shift();

            // If no more frames,
            // stop looping
            if (!self.frames.length) {
                self._isLooping = false;

            // Otherwise, _schedule the
            // next frame
            } else {
                raf(this._runFrame);
            }

            // Run the frame.  Note that
            // this may throw an error
            // in user code, but all
            // fastdom tasks are dealt
            // with already so the code
            // will continue to iterate
            if (fn) { fn(); }
        },

        /**
         * Adds a function to
         * a specified index
         * of the frame queue.
         *
         * @param  {Number}   index
         * @param  {Function} fn
         * @return {Function}
         */
        _schedule: function(index, fn) {

            // Make sure this slot
            // hasn't already been
            // taken. If it has, try
            // re-scheduling for the next slot
            if (this.frames[index]) {
                return this._schedule(index + 1, fn);
            }

            // Start the rAF
            // _loop to empty
            // the frame queue
            this._loop();

            // Insert this function into
            // the frames queue and return
            return (this.frames[index] = fn);
        }
    };

    return new DIO();

}(window));