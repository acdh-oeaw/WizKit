## Getting Started

1. Clone the repository: `$ git clone https://github.com/acdh-oeaw/wizkit`
2. Open the `wizkit.xpr` project in oXygen
3. Create a new file and select the "XML Document [Work]" in "Framework templates" / "WizKit MEI" and save it in `300_mei/works` or alternatively, open one of the files in `900_sample_files`
4. Have a look around and try out the forms (__Note__: For referencing persons and organisations, you can trigger completion with Ctrl+Space)
5. Run the HTML build by pressing the button with the green suitcase in the Author toolbar (or run the BuildHtml transformation scenario manually)
6. View the HTML output by pressing the (blue) button to the right of the one you just pressed (or opening `html/index.html` in your browser manually)

## What does the red button do?

The red button triggers the POWL (person, organisation, work, literature) process, a set of XSLTs that makes sure that everything has an ID and is hooked up correctly (i.e. persons and other entities are referenced by their respective IDs). You will probably need to run this after making changes in the forms for the HTML build to work.

## Git setup

After you have played with the WizKit for a little bit and want to use if for "real" work, we highly recommend renaming the old remote (so you can still get updates from there) and setting up your own.

    `git remote rename origin upstream`
    `git remote add origin <url to your remote>`

## If you get errors

If you get errors in the build, the most likely explanation is that some required data is missing. You could try:

+ running the POWL build (red suitcase) if you haven't already
+ trying to make sense of the error message(s) and go from there

## Thank you for your feedback

Please note that all of this is at an early stage and quite experimental. If you run into problems, feel free to open an issue or contact us directly. In any case, we are very interested to hear about your experiences with the WizKit and appreciate your feedback.

clemens.gubsch, paul.gulewycz, peter.provaznik AT oeaw.ac.at, respectively.
