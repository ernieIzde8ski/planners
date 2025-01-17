from pathlib import Path
from subprocess import run

from evilfunctools import partial

ROOT = Path(__file__).parent
TARGET = ROOT / "target"


def task_make_target():
    return {
        "actions": [partial(TARGET.mkdir, exist_ok=True)],
        "targets": [TARGET],
        "basename": "make-target",
    }


def task_build_typst_files():
    def build(source: Path, target: Path) -> None:
        _ = run(("typst", "compile", source, target))

    sources = ROOT.joinpath("src").glob("*.typ")
    for source in sources:
        target = TARGET / source.name
        target = target.with_suffix(".pdf")
        yield {
            "actions": [partial(build, source=source, target=target)],
            "targets": [target],
            "basename": "build-typst-file",
            "task_dep": ["make-target"],
        }
