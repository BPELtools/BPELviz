// AMD and non-AMD compatiblitiy inspired by http://tkareine.org/blog/2012/08/11/why-javascript-needs-module-definitions/ and https://github.com/blueimp/jQuery-File-Upload/blob/9.5.0/js/jquery.fileupload.js
(function(factory) {
    if (typeof define === 'function' && define.amd) {
        // Register as named AMD module. Anonymous registering causes "Mismatched anonymous define() module" in requirejs 2.9.1 when script is loaded explicitly and then loaded with requirejs
        define(['jquery'], factory);
    } else {
        // traditional browser loading: build restdoc-renderer object "renderer" without dependencies and inject it into window object
        window.renderer = factory(window.jQuery);
    }
}(function($) {
    /**
     * Initalizes the DOM elements on the page
     *
     * Has to be called when the DOM elements are available
     *
     * Currently, the DOM elements having the class "shrinkable" are handled
     */
    function initialize() {
        // all elements with "shrinkable" may be shrinked
        // alternative implementation: check for bpel_activity, but this class does not exist any more
        $("div.shrinkable").on("click", function(e) {
            var element = $(e.delegateTarget);

            // only shrink shrinkable children
            var children = element.children(".shrinkable");

            if (children.size() == 0) {
                // the element itself contains no shrinkable children
                //  shrink the element itself
                element.slideUp();
            } else {
                if (children.is(":visible")) {
                    children.slideUp();
                } else {
                    children.slideDown();
                }
            }
            return false;
        })
    }

    var module = {
        initialize: initialize
    }
    return module;
}));
