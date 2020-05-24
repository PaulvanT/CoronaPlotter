
import time, sys, keyboard, threading
from playsound import playsound


print("\n################################################################")
print(  "##################### NEW STUDY SESSION ########################")
print(  "################################################################")
print("\n(Please change the width of the Terminal window to 145 or larger)\n")
print("\n######################### SETUP ################################\n")
minutes = float(input("How many minutes do you want to allow per page?: "))
page = int(input("At what page will you start studying?:\t\t "))
goal = int(input("Untill which page do you want to study?:\t "))
print("\nPress the 's' key at any time to pause the program")

paused = False

def update_progress(progress, elapsed_time):
    if progress > 1:
        progress = 1
    barLength = 50 # Modify this to change the length of the progress bar
    status = ""
    if isinstance(progress, int):
        progress = float(progress)
    if not isinstance(progress, float):
        progress = 0
        status = "error: progress var must be float\r\n"
    block = int(round(barLength*progress))
    text = "\rPROGRESS: {0} {1}% {2} {3} {4} {5}".format( "▍"*block + "-"*(barLength-block), int(progress*100), status, "Elapsed time: ", int(elapsed_time), "seconds")
    sys.stdout.write(text)
    sys.stdout.flush()

def pause_handler():
    global paused
    while True:
        if keyboard.is_pressed('s'):
            paused = True
            input("\n \nPaused, press enter to continue ")
            print()
            paused = False

def studyclock(minutes_per_page, page_started, goal):
    pauser = threading.Thread(target=pause_handler)
    pauser.daemon = True
    pauser.start()
    current_page = int(page_started)
    seconds = int(minutes_per_page*60)
    print("\n######################### START ################################\n")
    print("\n==> You should be at page ", current_page, "now.\n")
    while current_page != goal:
        start = time.time()
        time.perf_counter()
        elapsed = 0
        while elapsed < seconds:
            start_pauze = time.time()
            pauze_duration = 0
            while paused:
                pauze_duration = time.time() - start_pauze
            start += pauze_duration
            elapsed = time.time() - start
            update_progress(elapsed/seconds, elapsed)
            time.sleep(0.1)
        current_page += 1
        playsound('Pingsound.mp3')
        if current_page != goal:
            for i in range(0,5):
                print(".")
                time.sleep(1)
            print("\n==> You should be at page ", current_page, "now.\n")

    print("\n\n########## STUDY SESSION FINISHED, CONGRATULATIONS! ############\n")

studyclock(minutes, page, goal)
