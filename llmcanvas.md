# AI Canvas — Project Plan

> An AI-first, real-time GUI surface where AI agents and humans share the same interface.
> Agents can control and observe it. Humans can see, click, pinch, and move things.
> Renders video, images, and text natively.

---

## The Core Idea

Most UIs are built for humans and then hacked to work with AI (screenshot → parse → click coordinates). This flips it — build the UI *for* AI agents from the ground up, with human interaction as a co-present feature.

Both AI and humans interact with the same live surface. Humans see what the agent is doing in real time. Agents get a clean structured view of state — no vision model guessing required.

---

## Why It Matters

- AI agents today interact with UIs in the worst way possible — brittle, slow, opaque
- Explainability and trust in agents is unsolved — a shared visual surface fixes this
- Nobody has built a UI layer designed AI-first from the ground up
- Timing is right: agent frameworks are maturing and need better UI primitives

---

## Key Concepts

### Two Representations, One Source of Truth

Every element has:
- **Semantic tree** — what things *are* (for the AI)
- **Visual tree** — what things *look like* (for humans)

Both stay in sync. One state update triggers both.

### The Node

```
Node {
  id: uuid
  semantic_type: enum (button, image, text, video, container, canvas)
  semantic_label: string        // "submit form" not "blue button"
  state: hashmap<string, any>
  properties: hashmap<string, any>
  transform: { x, y, z, scale, rotation }
  bounds: { width, height }
  children: []Node
  actions: []Action             // what can be done to this node
  observable: bool              // notify AI on change?
}
```

### The Action

```
Action {
  name: string          // "click", "drag", "input_text", "seek"
  parameters: schema    // typed params
  preconditions: []     // when is this valid
  effects: []           // what changes after
}
```

AI never guesses coordinates. It queries the semantic tree, gets valid actions, calls one by ID.

### Two Channels, One Convergence

```
Human:  touch/click/pinch → gesture recognizer → action dispatcher → state update → render
AI:     query tree → snapshot → decision → action call → state update → render
```

Both converge at state update → render.

---

## Architecture

```
Agent (LLM via function calls)
          ↓
  Action API (WebSocket or HTTP)
          ↓
  State Manager (semantic tree — source of truth)
          ↓
  Render Engine (visual tree + human input)
          ↓
  Display ← Human gestures feed back up
```

---

## What the AI Sees

Not pixels. A serialized semantic tree snapshot — JSON or binary:

```json
{
  "id": "root",
  "children": [
    {
      "id": "video-player-1",
      "semantic_type": "video",
      "semantic_label": "product demo video",
      "state": { "playing": false, "progress": 0.0 },
      "actions": ["play", "pause", "seek", "fullscreen"],
      "bounds": { "width": 800, "height": 450 }
    }
  ]
}
```

---

## Stack

| Layer | Technology |
|---|---|
| Render engine core | Zig + SDL3 or sokol (C interop) |
| Immediate mode UI | Dear ImGui (Zig bindings) — great fit for state-driven rendering |
| GPU rendering | WebGPU (wgpu) or sokol_gfx |
| Agent API | Go (HTTP/WebSocket server — you know it, ship it fast) |
| State manager | Zig |
| Agent integration | LLM function calling (OpenAI, Anthropic tools API) |

---

## Why Dear ImGui fits

ImGui rebuilds the UI every frame from state — which maps perfectly to the semantic tree. No retained mode complexity. State changes, render reflects it immediately. AI writes to state, humans see it instantly.

---

## Phases

### Phase 1 — Headless Semantic Tree (Start Here)
- Define the Node and Action data structures in Zig
- Build a state manager that holds the tree
- Write a simple serializer (tree → JSON)
- No rendering yet — just verify the model is right
- This is the hard and novel part

### Phase 2 — Agent API
- Build a Go HTTP/WebSocket server
- Endpoints: `GET /state` (returns tree snapshot), `POST /action` (dispatches action)
- Wire it to the Zig state manager via shared memory or socket
- Test with a simple script that calls actions and reads state

### Phase 3 — Basic Renderer
- Set up a window with SDL3 or sokol
- Render the semantic tree visually — boxes, text labels, basic shapes
- No polish yet — just prove visual tree and semantic tree are in sync

### Phase 4 — Human Input
- Handle mouse click, drag, pinch gestures
- Map gestures to actions in the semantic tree
- Human and AI actions go through the same action dispatcher

### Phase 5 — Rich Media
- Render images (PNG/JPEG nodes)
- Render video (SDL2_video or platform APIs)
- Render text with proper typography

### Phase 6 — AI Annotations Layer
- Show agent cursor on screen (humans can see where AI is looking)
- Highlight nodes the agent is interacting with
- Optional: show agent reasoning as overlay text

### Phase 7 — LLM Integration
- Connect a real LLM (Claude or GPT-4) via function calling
- Agent queries state, decides action, calls it
- Demo: AI navigates a simple app while human watches

### Phase 8 — SDK and Developer API
- Clean API for developers to define their own node types and actions
- Documentation
- Example apps

---

## First Milestone (Before Any Code)

Get the headless semantic tree working:

```
create Node struct → add children → serialize to JSON → dispatch an action → verify state changed
```

No window, no rendering, no HTTP. Just the data model. If this feels right, everything else builds on it.

---

## Key Differentiators

- AI gets structured state, not pixels — no brittle vision model needed
- Actions are typed with preconditions — no hallucinated coordinates
- Humans and AI share the same surface — explainability built in
- Built for real-time — both channels converge at 60fps render loop

---

## Resources and Prior Art

- webgpu-native / wgpu-rs — GPU rendering
- sokol — https://github.com/floooh/sokol — minimal C graphics, great Zig interop
- Dear ImGui — https://github.com/ocornut/imgui — immediate mode UI
- Zig SDL3 bindings — search GitHub
- Anthropic tool use docs — for agent function calling
- TigerBeetle source — example of serious Zig architecture

---

## Prerequisite

**Finish zigget first.**

zigget teaches you Zig fundamentals. This project requires you to fight hard architectural problems — you don't want to also fight the language at the same time. Come to this project with Zig confidence.

---

## Milestone Checklist

- [ ] Phase 1: Headless semantic tree
- [ ] Phase 2: Agent API (Go)
- [ ] Phase 3: Basic renderer
- [ ] Phase 4: Human input
- [ ] Phase 5: Rich media
- [ ] Phase 6: AI annotations layer
- [ ] Phase 7: LLM integration
- [ ] Phase 8: SDK and developer API
