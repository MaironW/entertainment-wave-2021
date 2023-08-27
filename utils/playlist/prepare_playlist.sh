playlist=$1  # playlist file
dest_path=$2 # path to send the videos

mkdir 4x3

while read -r line; do
    echo "$line"
    # Download files
    yt-dlp -o '%(title)s.%(ext)s' -f 'best[height<=480]' "$line"
done < "$playlist"

for video in *.mp4; do
    echo "$video"
    # Format new filename with lowercase and underscore
    new_video=$(echo $video | tr '-' ' ' | tr -s " " | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
    # Get video height
    h=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 "$video")
    # Compute video width
    w=$((h*4/3))
    # Crop to 4:3
    ffmpeg -i "$video" -vf crop="$w":"$h" "4x3/$new_video"
done

# Send all files to Raspberry Pi
scp 4x3/*.mp4 "$dest_path"

# Remove files from computer
rm *.mp4
rm 4x3/*.mp4