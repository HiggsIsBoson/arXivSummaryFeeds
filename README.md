# How to set up an auto feeder
Validaded with macOS Sequoia 15.6.

### Prerequisite
- Either Claude code CLI or ChatGPT Codex CLO installed in your local machine
- Claude code: `curl -fsSL https://claude.ai/install.sh | bash`, then launch and authenticate.
- ChatGPT Codex: ``, then launch and authenticate.

### Step1. Prepare a prompt script and example
- Specify the backend and model to use, customize the PROMPT in [summarize.sh](./summarize.sh) to fit to your interests, detailness, expertise etc.
- Edit the [hep-ex,quant-ph]/example.md for format preference (you may also just describe in the PROMPT).

### Step2: Set up a crontab (e.g. macOS)
e.g. Run 9pm everyday, output stdout/stderr only for the latest update:
```
crontab -e
0 21 * * * ABSPATH_TO_REPO/summarize.sh > SOMEWHERE/summarize.log 2>&1
```
Change `ABSPATH_TO_REPO` and `SOMEWHERE` to something appropriate.
