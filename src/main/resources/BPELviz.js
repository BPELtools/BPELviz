// AMD and non-AMD compatiblitiy inspired by http://tkareine.org/blog/2012/08/11/why-javascript-needs-module-definitions/ and https://github.com/blueimp/jQuery-File-Upload/blob/9.5.0/js/jquery.fileupload.js
(function(factory) {
    if (typeof define === 'function' && define.amd) {
        // Register as named AMD module. Anonymous registering causes "Mismatched anonymous define() module" in requirejs 2.9.1 when script is loaded explicitly and then loaded with requirejs
        define(['jquery', 'bootstrap3'], factory);
    } else {
        // traditional browser loading: build restdoc-renderer object "renderer" without dependencies and inject it into window object
        window.renderer = factory(window.jQuery);
    }
}(function($) {
    // divs are nested
    // thus, a tooltip is still being displayed when a child is hovered
    // we hide the old tooltip when a new element is entered
    var currentToolTip = false;

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

            var shrunkChildren = element.children(".shrunk");
            if (shrunkChildren.size() == 0) {
                // no shrunk children

                var children = element.children(".shrinkable:visible");
                if (children.size() == 0) {
                    // the element itself contains no shrinkable children
                    //  shrink the element itself
                    element.slideUp();
                    element.addClass("shrunk");
                } else {
                    // shrink them
                    children.slideUp();
                    children.addClass("shrunk");
                }
            } else {
                // children are shrunk
                // unshrink them
                shrunkChildren.slideDown();
                shrunkChildren.removeClass("shrunk");
            }

            // no more further event handling
            return false;
        });

        $("div[rel='popover']").on("mouseover", function(e) {
            var target = $(e.target);
            if (!currentToolTip || (currentToolTip[0] != target[0])) {
                // new element hovered
                if (currentToolTip) {
                    // if tooltip is shown the first time, there is no old tooltip, therefore the check for currentToolTip
                    currentToolTip.tooltip('hide');
                }
                currentToolTip = target.tooltip('show');
            }
        }).on("mouseleave", function(e) {
            $(e.target).tooltip('hide');
        });
    }

    var module = {
        initialize: initialize
    }
    return module;
}));