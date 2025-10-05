document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector("form");

  if (form) {
    form.addEventListener("submit", (event) => {
      const nome = document.querySelector("#user_nome").value.trim();
      const email = document.querySelector("#user_email").value.trim();
      const password = document.querySelector("#user_password").value.trim();

      if (!nome || !email || !password) {
        event.preventDefault();
        alert("Por favor, preencha todos os campos antes de cadastrar.");
      } else {
        alert("Formulário enviado! 🚀");
      }
    });
  }
});
