
$("h1").text("Hello again");

$(function() {
  return function() {
    return $("h1").animate({
      opacity: 0.5
    }, 500).animate({
      opacity: 1
    }, 500);
  };
});
