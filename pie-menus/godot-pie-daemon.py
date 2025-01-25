import socket
import subprocess
import shlex
import sys
import time

def execute_command(command: str):
    """Executes the given command in a non-blocking way."""
    try:
        # Use shell=True on Windows for proper command execution
        if sys.platform.startswith("win"):
            subprocess.Popen(command, shell=True)
        else:
            # Use shlex.split on Linux for safe command splitting
            subprocess.Popen(shlex.split(command))
    except Exception as e:
        print(f"Unexpected error: {e}")

def main():
    HOST = "127.0.0.1"  # Localhost
    PORT = 42069         # Arbitrary non-privileged port

    # Create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((HOST, PORT))

    print(f"Listening for UDP packets on {HOST}:{PORT}...")

    while True:
        try:
            # Receive data from the socket
            data, addr = sock.recvfrom(1024)  # Buffer size is 1024 bytes
            message = data.decode('utf-8').strip()
            print(f"Received message: {message} from {addr}")

            # Check if the message matches the expected format
            if message.startswith("exe: ") and message.endswith("%"):
                # Extract the command
                command = message[5:-1]  
                print(f"Executing command: {command}")
                execute_command(command)
            else:
                print("Invalid message format")

        except KeyboardInterrupt:
            print("Exiting...")
            break
        except Exception as e:
            print(f"Error: {e}")

    # Close the socket
    sock.close()

if __name__ == "__main__":
    time.sleep(8)
    main()

