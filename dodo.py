from collections import deque
from collections.abc import Callable, Generator, Iterable
from functools import partial
from pathlib import Path
from subprocess import run

ROOT = Path(__file__).parent
TARGET = ROOT / "target"


def is_visible(path: Path) -> bool:
    return path.name[:1] != "."


def is_public(path: Path) -> bool:
    return path.name[:1] not in (".", "_")


def rglob(
    __path: Path,
    __pattern: str,
    *,
    __filter: Callable[[Path], bool] | None = is_visible,
) -> Generator[Path]:
    stack = deque([__path])

    if __filter is None:

        def subdirs(dir: Path, /) -> Iterable[Path]:
            return filter(Path.is_dir, dir.iterdir())

    else:

        def subdirs(dir: Path, /) -> Iterable[Path]:
            return filter(lambda p: p.is_dir() and __filter(p), dir.iterdir())

    while stack:
        dir = stack.popleft()
        yield from filter(
            __filter,
            dir.glob(__pattern),
        )
        dirs = subdirs(dir)
        stack.extend(dirs)


def task_build_typst_files():
    def build(source: Path, target: Path) -> None:
        target.parent.mkdir(exist_ok=True)
        _ = run(("typst", "compile", source, target))

    source_root = ROOT.joinpath("src")
    sources = rglob(source_root, "*.typ", __filter=is_public)

    for source in sources:
        relative = source.relative_to(source_root)
        target = TARGET / relative
        target = target.with_suffix(".pdf")
        yield {
            "actions": [partial(build, source=source, target=target)],
            "targets": [target],
            "basename": "build-typst-file",
        }
