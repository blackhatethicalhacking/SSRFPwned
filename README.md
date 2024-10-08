# BHEH's SSRFPwned

<p align="center">
<a href="https://www.blackhatethicalhacking.com"><img src="https://www.blackhatethicalhacking.com/wp-content/uploads/2022/06/BHEH_logo.png" width="300px" alt="BHEH"></a>
</p>

<p align="center">
SSRFPwned is written by Chris "SaintDruG" Abou-Chabké from Black Hat Ethical Hacking and is designed for Offensive Security attacks. 
</p>

<p align="center">
<img src="https://camo.githubusercontent.com/82291b0fe831bfc6781e07fc5090cbd0a8b912bb8b8d4fec0696c881834f81ac/68747470733a2f2f70726f626f742e6d656469612f394575424971676170492e676966" width="350" height="1">
</p>
<h2 align="center"><u>Black Hat Ethical Hacking</u>

![summary](https://github-profile-summary-cards.vercel.app/api/cards/profile-details?username=blackhatethicalhacking&theme=monokai)

<p align="center">
  <a align="center" href="https://github.com/blackhatethicalhacking" target="_blank"><img src="https://img.shields.io/badge/Github-blackhatethicalhacking-green?style=for-the-badge&logo=github"></a>
</p>

<!--
**blackhatethicalhacking** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- 🔭 I’m currently working on ...
- 🌱 I’m currently learning ...
- 👯 I’m looking to collaborate on ...
- 🤔 I’m looking for help with ...
- 💬 Ask me about ...
- 📫 How to reach me: ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...
-->


# Description

SSRFPwned is a Penetration Testing and Bug Bounty Offensive Security Tool that automates the process of testing for Server Side Request Forgery (SSRF) vulnerabilities. SSRF is a type of vulnerability that allows attackers to make unauthorized requests to the internal resources of a server by manipulating user-supplied input. SSRFPwned automates the testing of thousands of URLs to identify potential SSRF vulnerabilities. It does this by injecting payloads into the query parameters of each URL and checking the response code to determine if a vulnerability exists. The Payloads are custom ones with multiple attack vectors, and you could also add more wordlists in case you want to even test for more, as it will copy the wordlist, merge them then start the attack.


# What Makes SSRFPwned Unique:

SSRFPwned is unique because it combines multiple sources for URL discovery, including the Wayback Machine, URLScan, and AlienVault. The tool is also highly customizable, allowing users to add their own payloads for testing specific types of SSRF vulnerabilities. Additionally, the tool is designed to be efficient and scalable, allowing users to test thousands of URLs at once. It is also special because of the way it filters the URLs based on using GF to specifically filter out with Regex only the ones that match the SSRF Pattern, but also cleaning the parameters from values so it can then inject it there. The way it checks also if it is vulnerable or not, checks also for reflected traces of the payload in the response and if it has 200 codes to give the result.
  
It is also Special well because you will:
  
![giphy](https://user-images.githubusercontent.com/13942386/222453411-18efb5a7-6546-4ed0-8bed-5eb6431597bc.gif)

# The Flow & Methodology

- Discovery - The tool begins by discovering URLs to test for SSRF vulnerabilities. It does this by using multiple sources including Wayback Machine, AlienVault, and URLScan.
- Filtering - The tool filters out URLs that are not relevant for testing SSRF vulnerabilities, such as image files or CSS files.
- It also greps using GF the patterns with Regex that matches the SSRF model and cleans the values of the parameters.
- Payload Injection - The tool then injects a variety of custom payloads into the query parameters of each URL. The payloads are designed to test for specific types of SSRF vulnerabilities.
- Testing - The tool tests each URL and payload combination by sending a request to the URL with the injected payload. It then checks the response code to determine if a vulnerability exists.
- Reporting - The tool generates a report of vulnerable URLs and the payloads that were successful in exploiting the vulnerability.

# Features:

- Automatic testing of thousands of URLs for SSRF vulnerabilities
- Supports multiple sources for URL discovery
- Automatic payload injection into query parameters of each URL
- Customizable payload list for testing specific types of SSRF vulnerabilities
- Supports HTTP and HTTPS protocols
- Provides detailed output including vulnerable URLs and payload used
- Saves results in an easily readable format for further analysis

# Expansion

Feel free to expand more Pocs, and integrate it, the idea is speed, and sending 1 curl, send a push!

# Requirements:

- waybackurls: This tool can be installed by running `go install github.com/tomnomnom/waybackurls@latest`

- cURL: This tool is commonly pre-installed on Kali Linux and Ubuntu, but can be installed by running `apt-get install curl` on Ubuntu or `brew install curl` on MacOS

- httpx: is a fast and multi-purpose HTTP toolkit that allows running multiple probes using the retryable HTTP library. To install it: `go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest`

- lolcat: `pip install lolcat` for rainbow beauty

- gf: `go install -v github.com/tomnomnom/gf@latest`

# Installation

`git clone https://github.com/blackhatethicalhacking/SSRFPwned.git`

`cd SSRFPwned`

`chmod +x SSRFPwned.sh`

`./SSRFPwned.sh`

# Screenshot

![Screenshot 2023-06-22 at 9 59 56 PM](https://github.com/blackhatethicalhacking/SSRFPwned/assets/13942386/e7bcbfa9-2420-48a3-976f-b49c23050f7b)


# Compatibility: 

This tool has been tested on Kali Linux, Ubuntu, and MacOS.


# Disclaimer

This tool is provided for educational and research purposes only. The author of this project is in no way responsible for any misuse of this tool. 
We use it to test under NDA agreements with clients and their consents for pentesting purposes and we never encourage misuse or take responsibility for any damage caused!

<h2 align="center">
  <a href="https://store.blackhatethicalhacking.com/" target="_blank">BHEH Official Merch</a>
</h2>

<p align="center">
Introducing our Merch Store, designed for the Offensive Security community. Explore a curated collection of apparel and drinkware, perfect for both professionals and enthusiasts. Our selection includes premium t-shirts, hoodies, and mugs, each featuring bold hacking-themed slogans and graphics that embody the spirit of red teaming and offensive security. 
Hack with style and showcase your dedication to hacker culture with gear that’s as dynamic and resilient as you are. 😊
</p>

<p align="center">

<img src="https://github.com/blackhatethicalhacking/blackhatethicalhacking/blob/main/Merch_Promo.gif" width="540px" height="540">
  </p>
