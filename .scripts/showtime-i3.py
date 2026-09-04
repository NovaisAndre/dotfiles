import pyautogui
import time
import random
import pyperclip
import os

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
    pyautogui.hotkey(modkey, 'h')
    open_kitty()
    pyautogui.typewrite('neo -D -c cyan')
    pyautogui.hotkey('enter')
    open_kitty()
    pyautogui.typewrite('neo -D -c cyan')
    pyautogui.hotkey('enter')
    pyautogui.hotkey(modkey, 'h')
    pyautogui.hotkey(modkey, 'shift', 'h')
    pyautogui.hotkey(modkey, 'l')
    pyautogui.hotkey(modkey, 'r')
    pyautogui.hotkey('l')
    pyautogui.hotkey('l')
    pyautogui.hotkey('l')
    pyautogui.hotkey(modkey, 'r')
    time.sleep(0.3)

def open_dev_setup():
    time.sleep(0.3)
    pyautogui.hotkey(modkey, '3')
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
    pyautogui.hotkey(modkey, '7')
    set_wallpaper('heart')
    pyautogui.hotkey(modkey, 'h')


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

    pyautogui.hotkey(modkey, 'v')
    open_kitty()
    pyautogui.hotkey('ctrl', 'shift', '-')
    pyautogui.typewrite('neofetch')
    pyautogui.hotkey('enter')
    pyautogui.hotkey(modkey, 'k')
    time.sleep(1)
    pyautogui.typewrite(' pf')
    time.sleep(1)
    pyautogui.typewrite('kanji')
    pyautogui.hotkey('ctrl', 'y')
    time.sleep(3)

def open_notes_obsidian():
    time.sleep(0.3)
    pyautogui.hotkey(modkey, '7')
    set_wallpaper('heart')

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

    # Open Obsidian
    pyautogui.hotkey(modkey, 'b')
    open_kitty()
    special_write('./Obsidian-1.6.5.AppImage & disown && exit')
    pyautogui.hotkey('enter')
    time.sleep(5)
    pyautogui.hotkey(modkey, 'h')
    pyautogui.hotkey(modkey, 'shift','q')
    pyautogui.hotkey('ctrl', 'g')

    time.sleep(2)

def open_music_thematic():
    time.sleep(0.3)
    pyautogui.hotkey(modkey, '9')
    set_wallpaper('tokyonight')
    time.sleep(0.5)
    pyautogui.hotkey(modkey, 'h')
    time.sleep(0.5)

    open_kitty()
    pyautogui.typewrite('ncspot')
    pyautogui.hotkey('enter')
    curtains()
    pyautogui.hotkey(modkey, 'v')
    open_kitty()
    pyautogui.typewrite('cava')
    pyautogui.hotkey('enter')
    pyautogui.hotkey(modkey, 'k')
    time.sleep(1)
    pyautogui.hotkey('w')
    pyautogui.typewrite('Thematic Mathematics')
    pyautogui.hotkey('enter')
    pyautogui.hotkey('l')
    time.sleep(1)
    pyautogui.hotkey('enter')
    time.sleep(5)

def open_music():

    time.sleep(0.3)
    pyautogui.hotkey(modkey, '9')
    set_wallpaper('tokyonight')
    time.sleep(0.5)
    pyautogui.hotkey(modkey, 'h')
    time.sleep(0.5)

    open_kitty()
    pyautogui.typewrite('ncspot')
    pyautogui.hotkey('enter')
    curtains()
    pyautogui.hotkey(modkey, 'v')
    open_kitty()
    pyautogui.typewrite('cava')
    pyautogui.hotkey('enter')
    pyautogui.hotkey(modkey, 'k')
    time.sleep(1)
    pyautogui.hotkey('shift', 'p')
    time.sleep(5)

def ascii_image_converter():
    time.sleep(1)
    pyautogui.hotkey(modkey, '4')

    open_kitty()
    
    seed = random.randint(0, len(wallpapers))
    set_wallpaper(wallpapers[seed])
    if seed >= len(wallpapers) - 3:
        seed = 0
    else:
        seed += 1

    def ascii(seed):
        pyperclip.copy('ascii-image-converter --color ~/.wallpapers/' + wallpapers[seed])
        time.sleep(0.5)
        pyautogui.hotkey('ctrl', 'shift', 'v')
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

def fightcade():
    pyautogui.hotkey(modkey, '8')
    pyautogui.hotkey(modkey, 'd')
    pyautogui.typewrite('fightcade')
    pyautogui.hotkey('enter')

def chrome_dev():
    pyautogui.hotkey(modkey, '1')
    pyautogui.hotkey(modkey, 'd')
    pyautogui.typewrite('chrome')
    pyautogui.hotkey('enter')
    time.sleep(3)
    pyautogui.hotkey('enter')

def chrome_miles():
    pyautogui.hotkey(modkey, '2')
    pyautogui.hotkey(modkey, 'd')
    pyautogui.typewrite('chrome')
    pyautogui.hotkey('enter')
    time.sleep(3)
    pyautogui.hotkey('tab')
    pyautogui.hotkey('tab')
    pyautogui.hotkey('tab')
    pyautogui.hotkey('enter')
    pyautogui.hotkey('ctrl', 'shift', 'n')
    pyautogui.typewrite('whats')
    pyautogui.hotkey('enter')
    pyautogui.hotkey(modkey, 'shift', '0')

def spiral():
    wait_time = 0.5

    pyautogui.hotkey(modkey, '4')

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
    def spiral(size):
        while(size > 0):
            pyautogui.hotkey(modkey, 'b')
            open_terminal()
            pyautogui.hotkey(modkey, 'v')
            open_terminal()
            pyautogui.hotkey(modkey, 'b')
            open_terminal()
            pyautogui.hotkey(modkey, 'h')
            pyautogui.hotkey(modkey, 'v')
            open_terminal()
            pyautogui.hotkey(modkey, 'k')
            size = size - 1
    spiral(1)

    time.sleep(1)
    pyautogui.hotkey('ctrl', 'c')
    pyautogui.typewrite('cowsay -p "Hello World"')
    pyautogui.hotkey('enter')

    time.sleep(3)

    while(term_counter > 0):
        pyautogui.hotkey(modkey, 'shift', 'q')
        term_counter -= 1


open_music()
open_notes_obsidian()
#open_notes()
ascii_image_converter()
spiral()
open_dev_setup()

