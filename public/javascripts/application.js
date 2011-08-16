// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// 
$(document).ready(function(){
    startTime();
    $("#signout").hide();
    $("#username").clickUsername();   
    $(".summary").changeWithAjax();
    $(".summary").mouseoverEvent();
    $(".summary").mouseoutEvent();     
});

jQuery.ajaxSetup({ 
    'beforeSend': function(xhr) {
        xhr.setRequestHeader("Accept", "text/javascript")
    }
})

function startTime(){
    var today=new Date();
    document.getElementById('timer').innerHTML=today;
    t=setTimeout('startTime()',500);
}

jQuery.fn.clickUsername = function() {
    this.click( function() { 
        $("#signout").show(function() {     
            $(window).one("click", function() {
                $("#signout").hide();
            });
        });
    });
}  

jQuery.fn.changeWithAjax = function() {
    this.live("change", function() {
        $.post($(this).parents().attr("action"), 
            $(this).parents().serialize() + '&_method=put&commit=Update', 
            null, "script");   
    }); 
}

jQuery.fn.mouseoverEvent = function() {
    this.live("mouseover", function() {
        $(this).css("background-color","yellow");
    });
}

jQuery.fn.mouseoutEvent = function() {
    this.live("mouseout", function() {
        $(this).css("background-color","white");
    });
}
