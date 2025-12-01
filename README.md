# OpenAI Structured Chat

### A Rails App for Designing, Validating & Testing OpenAI Structured Output Schemas

**OpenAI Structured Chat** is a Rails application for creating, editing, validating, and testing **OpenAI Structured Output JSON Schemas** using a chat interface.

This app helps you visually design schemas, enforce OpenAI validation rules, and test real structured responses directly from the OpenAI API—perfect for building AI agents, tool-calling interfaces, workflows, assistants, and schema-driven LLM apps.

---

## ✨ Features

### ✔ Schema Designer UI

* Create schemas with **name**, **model**, and **description**
* Add fields including:

  * `string`
  * `integer`
  * `float`
  * `boolean`
  * `enum` (with values)
  * `array` (with item type)
* Required flag support
* Live JSON Schema generation matching OpenAI’s required contract

### ✔ Validation Engine

* Enforces OpenAI Structured Output constraints:

  * Enum fields **must** have enum values
  * Array fields **must** have an item type
  * Enum & array fields **must be required**
  * Schema must contain **at least one required field**
  * Keys must be unique & valid

### ✔ Schema-to-Chat Integration

* Every Chat can have an associated schema
* Chats automatically display schema details in a Turbo frame
* Edit schema fields in a Turbo-powered modal
* Changes instantly update the UI without reloading

### ✔ OpenAI Structured Output Testing

* Send a prompt to OpenAI using the assigned schema
* Receive:

  * **Parsed Ruby hash**
  * **Formatted JSON text**
  * **Raw model response**
* Useful for debugging and tuning schemas

### ✔ Stimulus + Turbo Only

* All JS behavior (modal, schema field editing, schema selection) is built in Stimulus
* No custom webpack or JS frameworks needed

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/ktamulonis/openai-structure-chat.git
cd openai-structure-chat
```

---

## 2. Install dependencies

```bash
bundle install
```

If using importmap (default) → no JS bundler required.

---

## 3. Set up the database

```bash
rails db:create
rails db:migrate
```

---

## 4. Add your OpenAI API key

Run:

```bash
EDITOR="nano" bin/rails credentials:edit
```

Add:

```yaml
openai:
  api_key: sk-your-api-key-here
```

Save and exit.

---

## 5. Seed example schemas

The app ships with a seed file including common structured schemas (product info, article extractors, etc.).

Run:

```bash
rails db:seed
```

---

## 6. Start the server

```bash
rails server
```

Open:

```
http://localhost:3000
```

---

## 🧪 Usage

### 1. Create or select a schema

Chats include a schema selector at the top. Choose one or create a new one.

### 2. Edit schema fields

Click **Edit Schema**
A turbo-powered modal appears on the right side for managing fields.

### 3. Test structured output

Write a prompt in the chat and the model will return:

* Strictly validated structured data
* Matching your schema
* Parsed into Ruby & JSON views

Great for debugging and designing schemas for agent/tool APIs.

---

## 📁 Project Structure

### Key Models

* `StructuredSchema` – schema meta + validation + JSON schema generation
* `StructuredField` – field definitions & constraints
* `Chat` – user sessions for sending prompts
* `Message` – chat messages including structured outputs

### Key Controllers

* `StructuredSchemasController`
* `StructuredFieldsController`
* `ChatsController`
* `MessagesController`

### Key Stimulus controllers

* `modal_controller.js`
* `schema_fields_controller.js`
* `schema_select_controller.js`

### Key Views

* `chats/_schema_panel.html.erb`
* `structured_schemas/edit_fields.html.erb`
* `chats/show.html.erb`

---

## 🧩 Future Enhancements

* Drag-and-drop field reordering
* Schema import/export (JSON/YAML)
* Model selection (gpt-4o-mini, o3-mini, etc.) per schema
* Running multiple prompts batch-style
* Schema versioning
* Sharing schemas between users

---

## 🤝 Contributing

Contributions, PRs, and issues are welcome!

If you’d like to extend the schema designer or add validations for future OpenAI features, feel free to open an issue or submit a PR.

---

## 📝 License

MIT License — free to use commercially and personally.

---

## 👤 Author

**Kurt Tamulonis (@ktamulonis)**
Creator of *openai-structure-chat* and many other Rails + AI tools.

---

Enjoy the project — and feel free to reach out if you'd like help polishing the UI or extending functionality!

# openai-structure-chat
