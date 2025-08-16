#!/bin/bash

# ------------------------------------------------------------------
#  ____                      _   _           _     _____ _     _    
# |  _ \  _____      ___ __ | \ | | ___   __| | __|_   _| |__ | |_  
# | | | |/ _ \ \ /\ / / '_ \|  \| |/ _ \ / _` |/ _ \| | | '_ \| __| 
# | |_| | (_) \ V  V /| | | | |\  | (_) | (_| |  __/| | | | | | |_  
# |____/ \___/ \_/\_/ |_| |_|_| \_|\___/ \__,_|\___||_| |_| |_|\__| 
#                                                                  
#  by abdullah awan - The Ultimate YouTube Playlist Downloader
# ------------------------------------------------------------------

function show_banner() {
    echo -e "\033[1;36m"
    cat << "EOF"
    ____                      _   _           _     _____ _     _    
   |  _ \  _____      ___ __ | \ | | ___   __| | __|_   _| |__ | |_  
   | | | |/ _ \ \ /\ / / '_ \|  \| |/ _ \ / _` |/ _ \| | | '_ \| __| 
   | |_| | (_) \ V  V /| | | | |\  | (_) | (_| |  __/| | | | | | |_  
   |____/ \___/ \_/\_/ |_| |_|_| \_|\___/ \__,_|\___||_| |_| |_|\__| 
EOF
    echo -e "\033[1;35m\n   by abdullah awan - The Ultimate YouTube Playlist Downloader\033[0m"
    echo -e "\033[1;33m--------------------------------------------------------------\033[0m"
}

# Main function
function main() {
    clear
    show_banner
    
    # Check if yt-dlp is installed
    if ! command -v yt-dlp &> /dev/null; then
        echo -e "\n\033[1;33m[!] Installing yt-dlp...\033[0m"
        sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
        sudo chmod a+rx /usr/local/bin/yt-dlp
        echo -e "\033[1;32m[✓] yt-dlp installed successfully!\033[0m"
    fi

    # Get playlist URL
    echo -e "\n\033[1;37mEnter YouTube Playlist URL:\033[0m"
    read -p " >> " url
    
    if [ -z "$url" ]; then
        echo -e "\033[1;31m[!] Error: No URL provided\033[0m"
        exit 1
    fi

    # Create download directory
    mkdir -p ~/YouTube_Downloads
    
    # Download options
    echo -e "\n\033[1;37mSelect download format:\033[0m"
    echo " 1) High Quality MP3 (Recommended)"
    echo " 2) HD Video (1080p)"
    echo " 3) 4K Video (If available)"
    read -p " >> " choice
    
    case $choice in
        1)
            format_options=(
                --extract-audio
                --audio-format mp3
                --audio-quality 0
                --embed-thumbnail
                --add-metadata
            )
            ;;
        2)
            format_options=(
                -f "bestvideo[height<=1080]+bestaudio/best"
                --merge-output-format mp4
            )
            ;;
        3)
            format_options=(
                -f "bestvideo[height<=2160]+bestaudio/best"
                --merge-output-format mp4
            )
            ;;
        *)
            echo -e "\033[1;33m[!] Defaulting to MP3 format\033[0m"
            format_options=(
                --extract-audio
                --audio-format mp3
                --audio-quality 0
                --embed-thumbnail
                --add-metadata
            )
            ;;
    esac

    # Common options
    common_options=(
        --ignore-errors
        --no-warnings
        --yes-playlist
        --output "~/YouTube_Downloads/%(playlist_title)s/%(title)s.%(ext)s"
    )

    # Start download
    echo -e "\n\033[1;32m[+] Downloading playlist...\033[0m"
    yt-dlp "${common_options[@]}" "${format_options[@]}" "$url"
    
    echo -e "\n\033[1;32m[✓] Download complete!\033[0m"
    echo -e "\033[1;37mFiles saved in: ~/YouTube_Downloads\033[0m"
}

main
