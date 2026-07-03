# How to set up an auto feeder

### Prerequisite
- Claude code CLI at your local machine

### Step1. Prepare a prompt script

```
#!/bin/bash
set -euo pipefail

DATE=$(date +%Y-%m-%d)
REPO="absolute path to the local git repo"  #FIXME

# Loop over sub-directories (e.g. hep-ex, quant-ph)
for CATEGORY in hep-ex quant-ph; do
    OUTPUT=${REPO}/${CATEGORY}/${DATE}.md    
    echo "Fetching ${CATEGORY}..."
    claude --print "
Generate a summary of new arXiv papers under the ${CATEGORY} category:
https://arxiv.org/list/${CATEGORY}/new
in Japanese. I am mostly expert of LHC/SUSY/dark matter etc. so feel free to aggressively comaptify but more introduction is welcomed in summarying quant-ph papers.
For quant-ph, I'm particularly interested in the hardware development and sensing application.
The format of the summary is the following:

# arXiv ${CATEGORY} Daily Summary - ${DATE}

## 注目論文

各論文について：
- **タイトル（英語）**
- 著者
- arXivリンク (https://arxiv.org/abs/XXXX.XXXXX)
- 日本語要約（3-10文）
- キーワード

Pick up the most important ones if there are too many (preferrably 5-10 per day).
" > "${OUTPUT}"
    
    echo "Saved: ${OUTPUT}"
done

# git push
cd "${REPO}"
git add .
git commit -m "arXiv daily summary ${DATE}"
git push
cd -

echo "Done!"
```

### Step2: Set up a crontab
e.g. Run 9pm everyday, output stdout/stderr only for the latest update:
```
crontab -e
0 21 * * * ~/scripts/arxiv_summary.sh > ~/scripts/arxiv_summary.log 2>&1
```
