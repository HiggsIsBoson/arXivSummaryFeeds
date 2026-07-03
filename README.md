# How to set up an auto feeder
Validaded with macOS Sequoia 15.6.

### Prerequisite
- Claude code CLI at your local machine
  * `curl -fsSL https://claude.ai/install.sh | bash`
  * Launch with `claude` command and authenticate.


### Step1. Prepare a prompt script
e.g.  See [summarize.sh](./summarize.sh)

### Step2: Set up a crontab
e.g. Run 9pm everyday, output stdout/stderr only for the latest update:
```
crontab -e
0 21 * * * ABSPATH_TO_REPO/summarize.sh > SOMEWHERE/summarize.log 2>&1
```
Change `ABSPATH_TO_REPO` and `SOMEWHERE` to something appropriate.
