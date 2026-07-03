# arXiv hep-ex Daily Summary - 2026-07-03

本日の `hep-ex/new` を確認しました。新規投稿3本、cross-list 7本、replace 8本です。**quant-ph からの cross-list は本日ゼロ**でした（ハードウェア開発・センシング関連でご興味に沿うものは検出器タイミング技術の [5] くらいです）。あなたのご専門を踏まえ、hep-ex 本体は簡潔に、周辺のダークマター/検出器系を少し厚めにまとめます。

---

## 新規投稿（New Submissions）

### [1] Study of ZZ and ZH production in the bb$\tau\tau$ final state and search for high-mass spin-0 and spin-1 resonances at $\sqrt{s}$ = 13 TeV
- **著者**: CMS Collaboration
- **リンク**: https://arxiv.org/abs/2607.01589
- **要約**: Run2 全統計 138 fb⁻¹ を使い、bb$\tau\tau$ 終状態で ZZ / ZH 生成を初測定。同時に spin-0 共鳴 X→ZZ（0.2–5 TeV）と spin-1 共鳴 Z'→ZH（0.5–6 TeV）を探索。95% CL 上限は X→ZZ で 300 pb–24 fb、Z'→ZH で 0.4 pb–12 fb。SM と consistent、新規性は bb$\tau\tau$ チャンネルでの初アプローチ。標準的な heavy resonance サーチなので特に驚きはなし。
- **キーワード**: CMS, ZZ/ZH, heavy resonance, bbττ, EXO

### [2] Heavy-Flavor Electron Classification Using Hadronic Environment as Point Cloud
- **著者**: Jingyu Zhang, Wanbing He, Long Ma
- **リンク**: https://arxiv.org/abs/2607.02225
- **要約**: charm(D)/bottom(B) 半レプトン崩壊由来の電子を、周囲のハドロン環境を point cloud として表現し Transformer 等の set-based ML で分別。アーキテクチャ間で性能差はほぼなく、「D/B ハドロン構造の本質的類似性」が性能上限を決めていると議論。40% efficiency で ~80% purity、手作り変数ベースラインを大幅に上回る。ML 手法論として一読の価値あり。
- **キーワード**: heavy flavor, point cloud, Transformer, electron ID, ML

### [3] Measurement of solar $pp$ neutrino flux with the new PandaX-4T data
- **著者**: PandaX Collaboration
- **リンク**: https://arxiv.org/abs/2607.02405
- **要約**: PandaX-4T Run2（2024–2026, 1.9 t·yr）で neutrino-electron 弾性散乱による太陽 pp ニュートリノフラックスを測定。Run0 と統合し (8.5±3.5)×10¹⁰ cm⁻²s⁻¹、標準太陽模型と整合。背景に対し 2.2σ で、電子反跳 165 keV 以下での pp-ν 散乱の初の positive indication。ダークマター実験（XENON/LZ 系列）を neutrino observatory として使う流れの好例で、あなたの興味と直結。
- **キーワード**: PandaX-4T, solar pp neutrino, ER, LXe TPC, solar model

---

## 注目 cross-list

### [5] Towards triggerless four-dimensional detectors for HEP collider experiments (from physics.ins-det)
- **著者**: Vladimir V. Gligorov
- **リンク**: https://arxiv.org/abs/2607.01496
- **要約**: LHC 実験のデータ量が「毎秒で全世界インターネットトラフィックの1/10超」という状況を背景に、ピコ秒タイミングを軸にした 4D 検出器のレビュー。CMS/ATLAS/LHCb アップグレードへの精密タイミング統合と、将来の「最初から triggerless」な検出器設計の可能性を議論。ハードウェア／リアルタイム処理に関心があれば読み物として面白い。
- **キーワード**: 4D detector, picosecond timing, triggerless, LHC upgrade

### [14] Enhancing Direct Detection of Higgsino Dark Matter (from hep-ph, replaced)
- **著者**: P. W. Graham, H. Ramani, S. S. Y. Wong
- **リンク**: https://arxiv.org/abs/2409.07768
- **要約**: SUSY WIMP の多くが排除される中、自然に inelastic DM を実現する Higgsino に着目。準縮退状態間の散乱が invisible になる領域を、"luminous dark matter"（up-scatter した Higgsino が大型ニュートリノ検出器内で photon 崩壊）で探索。Pb/U を検出器周囲に配置、地球内 U/Th、LMC 由来の高速テールも活用し JUNO/SNO+/KamLAND/Borexino の感度を大幅向上、残存パラメータ空間をカバーし得ると主張。SUSY×DM のあなたの専門にドンピシャ。
- **キーワード**: Higgsino, inelastic/luminous DM, SUSY, JUNO/SNO+

### その他 cross-list（簡潔に）
- **[7] WavePID (physics.ins-det)** — IceCube で単一 PMT の ns タイミング時系列を使い 5–100 GeV のフレーバー識別を GNN に上乗せ改善。https://arxiv.org/abs/2607.02078
- **[9] Non-unitary neutrino mixing / IceCube DeepCore 8yr (hep-ph)** — α₃₃ > −0.027 (90% CL) など非ユニタリ性に新制限。https://arxiv.org/abs/2607.02355
- **[4] Electron stability constrains neutrino time delays (hep-ph)** — Lorentz 破れによる ν 時間遅延を電子安定性から両側制約。https://arxiv.org/abs/2607.01339
- **[8] $B_s→D_s^{**}\ell\nu$ SM/BSM 解析 (hep-ph)**、**[10] Event-axis TMD (hep-ph)**、**[6] SAM-3.0 cumulants (hep-ph)** はフレーバー/QCD 系。

---

## replace で目を引くもの
- **[13] CMS 光子融合 W⁺W⁻ 生成 + EFT 解釈** — γγ→WW を観測、σ_total = 643⁺⁸²₋₇₈ fb、dim-8 aQGC に強い制限。https://arxiv.org/abs/2601.21574
- **[11] RF励起磁場による axion haloscope 感度向上**（0.3–1桁）、**[16] Cavity multimode で高周波重力波検出** — キャビティ×センシング系で、ハードウェア興味に近い。https://arxiv.org/abs/2408.16229 / https://arxiv.org/abs/2601.03341
- **[12] MEG II の Transformer トラッキング**（μ→eγ 感度 ~10% 向上）。https://arxiv.org/abs/2512.19482

---

**総評**: 本日の hep-ex 目玉は **[3] PandaX-4T の太陽 pp-ν**（DM 検出器の ν 天文台化）と、あなたの専門直撃の **[14] Higgsino DM の luminous detection**。quant-ph からの cross-list は本日なく、ハードウェア/センシング枠は [5] 4D検出器・[7] IceCube タイミング・[11]/[16] のキャビティ系が該当します。quant-ph 本体の新着をご覧になりたい場合は、`quant-ph/new` を別途取得して背景厚めでまとめますので言ってください。
