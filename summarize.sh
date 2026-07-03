#!/bin/bash
set -euo pipefail

DATE=$(date +%Y-%m-%d)

MODEL="claude-opus-4-6"
#MODEL="claude-sonnet-4-6"

REPO="absolute path to the local git repo"  #FIXME

# Loop over sub-directories (e.g. hep-ex, quant-ph)
for CATEGORY in hep-ex quant-ph; do
    OUTPUT=${REPO}/${CATEGORY}/${DATE}.md    

    echo "Fetching ${CATEGORY}..."
    claude --model ${MODEL} --verbose --print "
Please generate a summary of new arXiv papers under the ${CATEGORY} category in Japanese. 
Pick up up to 10 papers from https://arxiv.org/list/${CATEGORY}/new and summarize each in the follwoing format:

# arXiv ${CATEGORY} Daily Summary - ${DATE}

## 注目論文

各論文について：
- **タイトル（英語）**
- 著者
- arXivリンク (https://arxiv.org/abs/XXXX.XXXXX)
- 日本語要約（3-10文）
- キーワード

I am mostly expert in LHC/SUSY/dark matter etc. so feel free to do aggressively for hep-ex but more introduction is appreciated for other categories.
For quant-ph, I'm particularly interested in the hardware development and sensing application.
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
