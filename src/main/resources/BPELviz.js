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
     * Initialises the DOM elements on the page
     *
     * Has to be called when the DOM elements are available
     *
     * Currently, the DOM elements having the class "shrinkable" are handled
     */
    function initialize() {
        $("button.collapseExpandToggleBtn").on("click", function(e) {
            var element = $(e.delegateTarget);
            var bpelElement = element.parent();

            if (element.hasClass("glyphicon-minus")) {
                // collapsed -> expand it
                element.removeClass("glyphicon-minus").addClass("glyphicon-plus").addClass("active");
                bpelElement.children("div.content").slideDown();
            } else {
                // expanded -> collapse it
                element.removeClass("glyphicon-plus").addClass("glyphicon-minus").removeClass("active");
                bpelElement.children("div.content").slideUp();
            }

            // no more further event handling
            return false;
        });

        // initialize tabs
        $('#SourceTabs a').click(function (e) {
            e.preventDefault();
            $(this).tab('show');
        })

        // enable click on elements
        $(".bpel").on("click", function(event) {
            // determine id of element
            var id = $(event.delegateTarget).attr("id");

            /* show source in "Source Extract" tab */
            var sourceId = "source-" + id;
            sourceId = sourceId.replace(/\./g,'\\.');
            var source = $("#" + sourceId).children().clone();
            $("#SourceExtractTab").empty().append(source);

            /* highlight source in "Full Source" tab. Doesn't work currently as we don't have the line numbers available */
            // highlight line number
            // $("#FullSource > div > div > table > tbody > tr > td.gutter > div.line.number2").addClass("highlighted")
            // highlight code fragment
            // $("#FullSource > div > div > table > tbody > tr > td.code > div > div.line.number2").addClass("highlighted")

            // don't show source for the parent element, just for the clicked one
            return false;
        });
    }

    var module = {
        initialize: initialize
    }
    return module;
}));
