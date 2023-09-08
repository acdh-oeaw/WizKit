const vrvOptions = {
  inputFrom: "mei",
  pageWidth: 3000,
  pageHeight: 20000,
  pageMarginLeft: 50,
  pageMarginTop: 0,
  scale: 30,
  adjustPageHeight: true,
  breaks: "auto",
  openControlEvents: true,
};
document.addEventListener("DOMContentLoaded", function (_event) {
  verovio.module.onRuntimeInitialized = function () {
    const vrvTk = new verovio.toolkit();
    Array.from(document.getElementsByTagName("script"))
      .filter(
        (el) =>
          el.type === "text/xmldata" &&
          el.id.startsWith("vrv-") &&
          el.id.endsWith("_xml")
      )
      .forEach(function (el) {
        const data = el.innerHTML;
        const renderId = el.id.replace(/_xml$/, "_svg");
        const svg = vrvTk.renderData(data, vrvOptions);
        document.getElementById(renderId).innerHTML = svg;
      });
  };
});
