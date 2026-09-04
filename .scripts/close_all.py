import pyautogui
import time

time.sleep(1)

modkey = 'winleft'

def close_workspace(number):
    time.sleep(0.3)
    pyautogui.hotkey(modkey , str(number))
    pyautogui.hotkey(modkey , 'shift', 'q')
    pyautogui.hotkey(modkey , 'shift', 'q')
    pyautogui.hotkey(modkey , 'shift', 'q')
    pyautogui.hotkey(modkey , 'shift', 'q')
    time.sleep(0.3)

pyautogui.hotkey(modkey , 'enter')
time.sleep(1)
pyautogui.typewrite('tmux kill-server')
pyautogui.hotkey('enter')
pyautogui.hotkey(modkey , 'shift', 'q')

for i in range(3, 10):
    close_workspace(i)
