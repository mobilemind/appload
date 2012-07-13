# Appload

Appload is a simple page that does a Javascript-based redirect to a URL parameter. Use
this to help launch an iOS app using the URL protocol scheme for the app from an iBooks
hyperlink.

A very simple example to start the Message app is:

<http://mmind.me/appload.htm?target=sms:366466>

## Install
No installation required, a minimized & compressed
[hosted Appload page](http://mmind.me/appload.htm "appload") is a available for use.

I plan to also host it here on github via gh-pages

## Use

### iBooks
Add a regular hyperlink to your iBooks app that would normally just open Mobile Safari.
Make the href/URL of the hyperlink point to one of the hosted Appload pages and append
an URI encoded version of the desired app's URI protocol scheme-- _specificially_ use
JavaScript `encodeURIComponent(string)`. For example:
````javascript
myRedirectURL = 'http://mmind.me/appload.htm?target=' + encodeURIComponent(myTargetAppURL);
````
or if you choose to pre-encode a URL like `imdb:///find?q=caddyshack` becomes

<http://mmind.me/appload.htm?target=imdb%3A%2F%2F%2Ffind%3Fq%3Dcaddyshack>
 
### Android or other platforms
A use case for Android, another platform, or other iOS apps is unclear to me.
If you have one, let me know. I'm willing to adapt or extend this project.

## Examples
Example calls are also available online at: <http://mmind.me/appload-examples.htm>.

## Compatibility
Intended for use with iBooks 2.x or higher on iOS 5.1 or higher.

## License

MIT License - <http://www.opensource.org/licenses/mit-license.php>

Appload
Copyright (c) 2012 Tom King <mobilemind@pobox.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
