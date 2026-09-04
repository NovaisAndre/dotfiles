# Laptop Medium
xrandr --output eDP-1 --primary --mode 1280x720 --pos 0x0 --rotate normal --output HDMI-1 --off --rate 40

# Monitor Low  
xrandr --output eDP-1 --off --output HDMI-1 --mode 720x400 --pos 0x0 --rotate normal

# Monitor Big
xrandr --output eDP-1 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal

# Monitor Medium
xrandr --output eDP-1 --off --output HDMI-1 --mode 1280x720 --pos 0x0 --rotate normal

# Stacked Medium
xrandr --output eDP-1 --primary --mode 1280x720 --pos 0x1080 --rotate normal --output HDMI-1 --mode 1280x720 --pos 0x0 --rotate normal

# Stacked Big
xrandr --output eDP-1 --primary --mode 1280x720 --pos 0x2160 --rotate normal --output HDMI-1 --mode 3840x2160 --pos 0x0 --rotate normal
