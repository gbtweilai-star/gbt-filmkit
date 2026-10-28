# filmkit

**One capability bit from GBT V8, packaged standalone.** No. 35 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 柔性影片产线（清单制·任意场/镜增删重制·主人令 2026-09-26）：manifest.json 为唯一真相（场=音频+3镜prompt，镜=图+运镜）；list/gen/seg/build/add/rm 六命令；产出自动绑触手（asset_bindings 台账）；跳过/指定场装配支持做预告与片段

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-filmkit.git
cd gbt-filmkit
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_filmkit info                  # capability card
python -m gbt_filmkit spec --json           # machine-readable contract
python -m gbt_filmkit check --payload '{}'
python -m gbt_filmkit run   --payload '{}'
```

Real `info` output from this machine:

```text
filmkit  (creation)  v1.0.0
----------------------------------------
柔性影片产线（清单制·任意场/镜增删重制·主人令 2026-09-26）：manifest.json 为唯一真相（场=音频+3镜prompt，镜=图+运镜）；list/gen/seg/build/add/rm 六命令；产出自动绑触手（asset_bindings 台账）；跳过/指定场装配支持做预告与片段

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : list, gen, seg, build, add, rm
```

Wire a real implementation:

```python
from gbt_filmkit import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`list`、`gen`、`seg`、`build`、`add`、`rm`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.14s
```

## Provenance

| field | value |
|---|---|
| capability | `filmkit` |
| domain | `creation` |
| handler | `filmkit` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [creation/filmkit](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/filmkit.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
