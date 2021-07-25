# coding: utf-8
import time, sys, keyboard, threading
from playsound import playsound

paused = False
quit = False

def initialise():
    print("\n################################################################")
    print(  "##################### NEW STUDY SESSION ########################")
    print(  "################################################################")
    print("\n")
    print("\n######################### SETUP ################################\n")
    minutes = float(input("How many minutes do you want to allow per page?: "))
    page = int(input("At what page will you start studying?:\t\t "))
    goal = int(input("Untill which page do you want to study?:\t "))
    print("\nPress the 's' key at any time to pause the program")
    return [minutes, page, goal]

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
    text = '\rPROGRESS: {0} {1}% {2} {3} {4} {5}'.format('▎'*block + '-'*(barLength-block), int(progress*100), status, 'Elapsed time: ', int(elapsed_time), 'seconds')
    sys.stdout.write(text)
    sys.stdout.flush()

def pause_handler():
    global paused
    global quit
    while True:
        time.sleep(0.5)
        if keyboard.is_pressed('s'):
            paused = True
            user_input = str(input("\n \nPaused, press Enter to continue \nType 'quit' + Enter to stop \n"))
            if "quit" in user_input:
                quit = True
            paused = False

def studyclock(inputs):
    global paused
    global quit
    minutes_per_page = inputs[0]
    page_started = inputs[1]
    goal = inputs[2]
    current_page = int(page_started)
    seconds = int(minutes_per_page*60)
    print("\n######################### START ################################\n")
    print("\n==> You should be at page ", current_page, "now.\n")

    # Main loop
    while (current_page != goal + 1) and not quit:
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
            if quit:
                break
            time.sleep(0.5)
        current_page += 1
        if not quit: 
            playsound('Bell_sound.mp3')
            if (current_page != goal + 1):
                for _ in range(0,5):
                    print(".")
                    time.sleep(1)
                print("\n==> You should be at page ", current_page, "now.\n")

    print("\n\n################ STUDY SESSION FINISHED ###################\n")

    # Restart a session
    restart =  input("Do you want to restart a session? (y/n): ")
    if "y" in restart:
        quit = False
        studyclock(initialise())

def main():
    pauser = threading.Thread(target=pause_handler)
    pauser.daemon = True
    pauser.start()
    studyclock(initialise())

if __name__ == "__main__":
    main()
