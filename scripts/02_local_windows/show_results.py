"""Print the text outputs of an executed notebook (device, timings, MAE table, file check).

Usage: python show_results.py 04b_test_executed.ipynb
"""
import json
import sys

sys.stdout.reconfigure(errors="replace")  # Windows consoles choke on some characters

path = sys.argv[1] if len(sys.argv) > 1 else "04b_test_executed.ipynb"
with open(path, encoding="utf-8") as f:
    nb = json.load(f)

SKIP = ("HF_TOKEN", "huggingface_hub", "it/s", "B/s", "safetensors", "symlink")

for cell in nb["cells"]:
    if cell["cell_type"] != "code":
        continue
    for out in cell.get("outputs", []):
        if out.get("output_type") == "error":
            print("ERROR:", out.get("ename"), out.get("evalue"))
            continue
        text = out.get("text") or out.get("data", {}).get("text/plain", "")
        text = "".join(text) if isinstance(text, list) else text
        if out.get("name") == "stderr" or not text.strip() or text.startswith("<Figure"):
            continue
        lines = [ln for ln in text.splitlines() if not any(s in ln for s in SKIP)]
        if lines:
            print("\n".join(lines))
            print("-" * 60)
