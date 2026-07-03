# How to set up an auto feeder

### Prerequisite
- Claude code CLI at your local machine

### Step1. Prepare a prompt script
e.g.  See [example_script.sh](./example_script.sh)

### Step2: Set up a crontab (e.g. macOS)
e.g. Run 9pm everyday, output stdout/stderr only for the latest update:
```
crontab -e
0 21 * * * ABSPATH_TO_REPO/example_script.sh > SOMEWHERE/example_script.log 2>&1
```
Change `ABSPATH_TO_REPO` and `SOMEWHERE` to something appropriate.
