import pyautogui
import time
import random
import pyperclip
import os
import sys

time.sleep(1)

wallpaper_dir = os.path.expanduser('~/.wallpapers')
modkey = 'winleft'

color_name_array = ['green', 'yellow', 'orange', 'red', 'blue', 'cyan', 'gold',
                    'rainbow', 'purple', 'pink','vaporwave', 'gray']

wallpapers = os.listdir(wallpaper_dir)

def special_write(string):
    pyperclip.copy(string)
    time.sleep(0.5)
    pyautogui.hotkey('ctrl', 'shift', 'v')
    time.sleep(0.5)

def set_wallpaper(name):
    time.sleep(0.3)
    pyautogui.hotkey(modkey, 'shift', 'w')
    pyautogui.typewrite(name)
    pyautogui.hotkey('enter')
    time.sleep(0.3)

def set_random_wallpaper():
    number = random.randint(0, len(wallpapers) - 1)
    set_wallpaper(wallpapers[number + 1])
    return wallpapers[number]
    

def open_kitty():
    time.sleep(0.3)
    pyautogui.hotkey(modkey, 'enter')
    time.sleep(1)

def curtains():
    time.sleep(0.3)
    pyautogui.hotkey(modkey, 'y')
    open_kitty()
    pyautogui.typewrite('neo -D -c cyan')
    pyautogui.hotkey('enter')
    open_kitty()
    pyautogui.typewrite('neo -D -c cyan')
    time.sleep(0.3)
    pyautogui.hotkey('enter')
    time.sleep(0.3)
    pyautogui.hotkey(modkey, 'k')
    time.sleep(0.3)
    pyautogui.hotkey(modkey, 'space')
    time.sleep(0.3)
    pyautogui.hotkey(modkey, 'i')
    time.sleep(0.3)

def open_dev_setup():
    time.sleep(0.3)
    # pyautogui.hotkey(modkey, '3')
    set_wallpaper('twobe')
    open_kitty()
    pyautogui.typewrite('tmux')
    pyautogui.hotkey('enter')
    curtains()
    pyautogui.typewrite('tmux-sessionizer')
    pyautogui.hotkey('enter')
    time.sleep(0.3)

def open_notes():
    time.sleep(0.3)
    set_wallpaper('heart')

    open_kitty()
    pyautogui.typewrite('tmux')
    pyautogui.hotkey('enter')
    curtains()
    pyautogui.typewrite('tmux-sessionizer')
    pyautogui.hotkey('enter')
    time.sleep(1)
    pyautogui.typewrite('notes')
    time.sleep(1)
    pyautogui.hotkey('enter')
    time.sleep(1)
    pyautogui.typewrite('nvim .')
    pyautogui.hotkey('enter')
    time.sleep(1)
    pyautogui.typewrite(' pf')
    time.sleep(1)
    pyautogui.typewrite('kanji')
    pyautogui.hotkey('ctrl', 'y')
    time.sleep(3)

def open_notes_obsidian():
    time.sleep(0.3)
    set_wallpaper('heart')

    # Open Obsidian
    open_kitty()
    pyautogui.hotkey(modkey, 'i')
    special_write('./Obsidian-1.6.5.AppImage & disown && exit')
    pyautogui.hotkey('enter')
    time.sleep(5)
    pyautogui.hotkey(modkey, 'j')
    pyautogui.hotkey(modkey, 'shift','q')
    pyautogui.hotkey('ctrl', 'g')

    # Open Notes
    open_kitty()
    pyautogui.typewrite('tmux')
    pyautogui.hotkey('enter')
    time.sleep(0.5)
    pyautogui.typewrite('tmux-sessionizer')
    pyautogui.hotkey('enter')
    time.sleep(1)

    pyautogui.typewrite('notes')
    time.sleep(1)
    pyautogui.hotkey('enter')
    time.sleep(1)
    pyautogui.typewrite('nvim .')
    pyautogui.hotkey('enter')


    time.sleep(2)

def open_music_thematic(music_name):
    set_wallpaper('tokyonight')
    time.sleep(1)

    open_kitty()
    pyautogui.typewrite('ncspot')
    pyautogui.hotkey('enter')
    curtains()
    open_kitty()
    pyautogui.typewrite('cava')
    pyautogui.hotkey('enter')
    pyautogui.hotkey(modkey, 'k')
    time.sleep(1)
    pyautogui.hotkey('w')
    pyautogui.typewrite(music_name)
    pyautogui.hotkey('enter')
    time.sleep(1)
    pyautogui.hotkey('l')
    time.sleep(2)
    pyautogui.hotkey('enter')
    time.sleep(3)

def open_music():
    set_wallpaper('tokyonight')
    time.sleep(0.5)
    pyautogui.hotkey(modkey, 'shift', 't')


    open_kitty()
    pyautogui.typewrite('ncspot')
    pyautogui.hotkey('enter')

    open_kitty()
    pyautogui.typewrite('cava')
    pyautogui.hotkey('enter')
    time.sleep(1)

    pyautogui.hotkey(modkey, 'j')
    pyautogui.hotkey(modkey, 'space')

    pyautogui.hotkey('shift', 'p')

    pyautogui.hotkey(modkey, 'i')
    time.sleep(3)

def ascii_image_converter():
    time.sleep(1)

    seed = random.randint(0, len(wallpapers))
    set_wallpaper(wallpapers[seed])

    open_kitty()
    if seed >= len(wallpapers) - 3:
        seed = 0
    else:
        seed += 1

    def ascii(seed):
        special_write('ascii-image-converter --color ~/.wallpapers/' + wallpapers[seed])
        pyautogui.hotkey('ctrl', 'shift', '-')
        time.sleep(0.5)
        pyautogui.hotkey('enter')
        time.sleep(2)
        pyautogui.hotkey('ctrl', 'l')

    ascii(seed)
    seed += 1
    ascii(seed)
    seed += 1
    ascii(seed)

    pyautogui.hotkey(modkey, 'shift', 'q')
    time.sleep(1)

def spiral():
    wait_time = 1

    time.sleep(wait_time)

    pyautogui.hotkey(modkey, 'y')

    time.sleep(wait_time)

    set_wallpaper('fibo')

    term_counter = 0
    def open_terminal():
        nonlocal term_counter
        pyautogui.hotkey(modkey, 'enter')
        time.sleep(wait_time)
        neo_color = 'neo -D -c ' + color_name_array[term_counter%len(color_name_array)]
        time.sleep(wait_time)
        pyautogui.typewrite(neo_color)
        pyautogui.hotkey('enter')
        term_counter += 1
        

    open_terminal()
    def spiral_inside(size):
        while(size > 0):
            open_terminal()
            size = size - 1
    spiral_inside(5)

    time.sleep(wait_time)
    pyautogui.hotkey(modkey, 'k')
    time.sleep(wait_time)
    pyautogui.hotkey('ctrl', 'c')
    pyautogui.hotkey('ctrl', 'shift', '-')
    pyautogui.hotkey('ctrl', 'shift', '-')
    pyautogui.typewrite('cowsay -p "Hello World"')
    pyautogui.hotkey('enter')

    time.sleep(3)

    while(term_counter > 0):
        pyautogui.hotkey(modkey, 'shift', 'q')
        term_counter -= 1

def main():
    if len(sys.argv) != 2:
        sys.exit(1)

    function_name = sys.argv[1]
    
    if function_name == 'open_music':
        open_music()
    elif function_name == 'open_notes_obsidian':
        open_notes_obsidian()
    elif function_name == 'open_notes':
        open_notes()
    elif function_name == 'open_dev_setup':
        open_dev_setup()
    elif function_name == 'curtains':
        curtains()
    elif function_name == 'ascii_image_converter':
        ascii_image_converter()
    elif function_name == 'spiral':
        spiral()
    elif function_name == 'open_music_thematic':
        open_music_thematic('Thematic Mathematics')
    else:
        print('Invalid Function Name')

if __name__ == "__main__":
    main()





