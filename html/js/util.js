// show more functionality (u:listShowMore)
document.addEventListener("DOMContentLoaded", function (_event) {
  $("#show-text").click(function () {
    if ($(".about-text-hidden").hasClass("fade") == true) {
      $(".about-text-hidden").removeClass("fade").addClass("active");
      $(this).html("show less");
    } else {
      $(".about-text-hidden").removeClass("active").addClass("fade");
      $(this).html("show more");
    }
  });
});

function openAllAccordions(accordionId) {
  const prefix = accordionId?.length > 0 ? `#${accordionId} ` : "";
  document.querySelectorAll(prefix + ".collapse").forEach(function (el) {
    el.classList.add("show");
  });
  document
    .querySelectorAll(prefix + ".accordion-button")
    .forEach(function (el) {
      el.classList.remove("collapsed");
    });
}
function closeAllAccordions(accordionId) {
  const prefix = accordionId?.length > 0 ? `#${accordionId} ` : "";
  document.querySelectorAll(prefix + ".collapse").forEach(function (el) {
    el.classList.remove("show");
  });
  document
    .querySelectorAll(prefix + ".accordion-button")
    .forEach(function (el) {
      el.classList.add("collapsed");
    });
}
