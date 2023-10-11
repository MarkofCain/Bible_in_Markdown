# Bible_in_Markdown

## What This Code Does:
Bash script which converts The Holy Bible from an xml format to Markdown suitable for Obsidian

## How To Use This Code:
Download a Bible of your choice from [https://www.ph4.org/b4_mobi.php?q=zefania](https://www.ph4.org/b4_mobi.php?q=zefania)

Place that zip file in the same folder as this bash script.

Run the bash script.  In about 3 to 4 minutes you will have a master folder with 66 sub-folders (one for each Book of the Bible) and in each folder will be a file for each of the chapters in that particualr book.

## For Best Viewing Results:
The following css snippet will move the verse numbers to the side, gray them out slightly making for a less obstrusive reading of the text.  The verse numbers will be "there" but they won't be "in your face."

1. Turn CSS Snippets "On" in your settings:
- click on the "settings" icon
- under "OPTIONS" go to "Appearance"
- under "CSS snippets" toggle the switch to the "on" position 
2. In your snippets folder (the location of which should be displayed near the toggle switch) create the file "snippets.css"  - then add the following code:

<pre>
/* Bible Verses in preview */
.markdown-preview-view h6,
.cc-pretty-preview .markdown-preview-view h6
{
 position: relative;
  left: -4%;
  top: 18px;
  line-height: 0px;
  margin-top: -20px;
  margin-right: 3px;
  font-family: var(--font-family-preview);
  font-weight: 500;
  font-size: 10px !important;
  font-weight: bold;
  font-style: normal;
  color: var(--text-faint) !important;
}
 
</pre>
