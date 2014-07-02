FashionkredApp
==============

<H2>iPad app for fashionkred<H2>
<H3>Getting Started<H3>
<H4>Installation Steps:</H4>
<p>
<ol>
<li> Clone this repository. If you already have it cloned go to next step.</li>
<li>If you have Cocoapods installed on your machine go to step 3 else please follow below steps</li>
	<ol>
	<li> Open the Terminal</li>
	<li> Type below command and press enter.<pre><code>sudo gem update --system</code></pre> This command takes some time to execute. After it is done installing move to next step.</li>
	<li> Type below command in terminal and press enter.<pre><code>sudo gem install cocoapods</code></pre>
		You may get the following prompt
		<pre><code>
		rake's executable "rake" conflicts with /usr/bin/rake
		Overwrite the executable? [yN]
		</code></pre>	
		Press y and hit enter.
	</li>
	<li> Execute this in terminal <pre><code>pod setup</code></pre> This process may take a while.</li>
	</ol>
	<p>You have successfully installed cocoapods on your machine.</p>

<li> In the terminal change your directory to the project directory. For this project inside FashionkredApp folder where there is a README file.</li>
<li> Execute the below command in terminal. **Make sure you are inside project directory**<pre><code>pod install</code></pre>This will install the cocoapods for the project</li>
<li>After it is done use FashionApp.xcworkspace to open project in xcode.</li>
<ol>
</p>
<strong>IMPORTANT: You must always open the .xcworkspace file and not .xcodeproj.<strong>
