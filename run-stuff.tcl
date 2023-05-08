#! /usr/bin/env tclsh

# Needs to be ran in a "wrapper script" due to issues with venv's activation and 
# lack of straightforward support for Tcl scripts.
catch {console show}

puts "Tcl web app runner"
puts "q - quit terminal"
puts "f - run frontend"
puts "b - run backend"
flush stdout ;# prevent gets stdin from behaving weirdly with the output
set c [string tolower [gets stdin]] ;# read 1 character from stdin channel

proc run_npm {} {
  exec >&@stdout npm run serve ;# >&@stdout is shorthand for showing exec output instead of capturing it
}

proc run_uvicorn {dir} {
  # exec >&@stdout $dir/venv/Scripts/activate ;# Activate venv
  catch {exec >&@stdout cmd /c $dir/venv/Scripts/activate.bat} err
  exec >&@stdout uvicorn app.main:app --reload ;# >&@stdout is shorthand for showing exec output instead of capturing it
}

while {$c != "q"} {
  if {$c == "f"} {
    puts "Running frontend . . ."
    # https://stackoverflow.com/questions/23285360/how-to-get-path-of-current-script
    # This 'frees' the Tcl script from being bound to project's absolute paths
    # "it works on my machine!!" begone.
    cd "[file dirname [file normalize [info script]]]/front-vue"
    run_npm
    break
  } elseif {$c == "b"} {
    puts "Running backend . . ."
    set backend_dir "[file dirname [file normalize [info script]]]/back-fastapi"
    cd $backend_dir
    run_uvicorn $backend_dir
    break
  } else {    
    puts stderr "Invalid input"
  }
  flush stdout
  set c [string tolower [gets stdin]]
}
