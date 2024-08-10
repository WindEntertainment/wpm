import cmd
import argparse
import os

class WPM(cmd.Cmd):
    prompt = '>> ' 
    intro = 'Welcome to Wind Package Manager. Type "help" for available commands.' 

    def do_setup(self, line):
        """Setup project"""

        try:
            os.mkdir(".wpm")
        except OSError as err:
            print("In this directory project was already setup")
            return False

        if not os.path.isdir('app'):
            print("You should make 'app' directory with sources of you application")
            return False

        os.system("cmake -B ./.wpm/build/ -S ./app/")

    def do_quit(self, line):
        """Exit the CLI."""
        
        return True

    def handle_command(self, command):
        if command == 'setup':
            self.do_setup('')
        else:
            print(f"Unknown command: {command}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog='wpm', description="Wind Package Manager")
    parser.add_argument('command', help='Command to run', choices=['setup'])

    args = parser.parse_args()

    cli = WPM()

    if args.command:
        cli.handle_command(args.command)
    else:
        cli.cmdloop()