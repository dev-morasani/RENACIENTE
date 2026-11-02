// ===============================================
// FILTRO DE TALLAS - RENACIENTE
// ===============================================

// Guardo las casillas de talla y las prendas de la vitrina
let casillasTallas = document.querySelectorAll(".opciones-tallas input");
let prendas = document.querySelectorAll(".vitrina .prenda");

// Esta funcion se ejecuta cada vez que el usuario
// marca o desmarca una casilla de talla
function filtrarPorTallas() {

    // ----- PASO 1: guardar las tallas marcadas -----
    let tallasMarcadas = [];

    for (let i = 0; i < casillasTallas.length; i++) {
        if (casillasTallas[i].checked === true) {
            tallasMarcadas.push(casillasTallas[i].value);
        }
    }

    // Muestro en consola para saber que va bien
    console.log("Tallas marcadas:", tallasMarcadas); //PRUEBA CONFIRMADA Y SE MUESTRA BIEN OKK

    // ----- PASO 2: revisar prenda por prenda -----
    let prendasVisibles = 0;

    for (let j = 0; j < prendas.length; j++) {

        let prenda = prendas[j];

        // Leo el atributo data-tallas de esta prenda
        let atributoTallas = prenda.getAttribute("data-tallas");
        let tallasDeLaPrenda = atributoTallas.split(" ");

        // Empiezo suponiendo que NO se debe mostrar
        let mostrar = false;

        // Si no hay tallas marcadas, muestro TODAS
        if (tallasMarcadas.length === 0) {
            mostrar = true;
        } else {
            // Si hay tallas marcadas, reviso si esta prenda
            // tiene AL MENOS UNA de las tallas marcadas
            for (let k = 0; k < tallasDeLaPrenda.length; k++) {
                for (let l = 0; l < tallasMarcadas.length; l++) {
                    if (tallasDeLaPrenda[k] === tallasMarcadas[l]) {
                        mostrar = true;
                        break;  // ya encontre una coincidencia, salgo del bucle interno
                    }
                }
                if (mostrar === true) {
                    break;  // ya se que la prenda se muestra, salgo del bucle externo
                }
            }
        }

        // ----- PASO 3: aplicar el resultado -----
        if (mostrar === true) {
            prenda.style.display = "";
            prendasVisibles = prendasVisibles + 1;
        } else {
            prenda.style.display = "none";
        }
    }

    console.log("Prendas visibles:", prendasVisibles);

    // ----- PASO 4: mensaje si no queda ninguna -----
    mostrarMensajeVacio(prendasVisibles);
}

// Funcion aparte para el mensaje de "sin resultados"
function mostrarMensajeVacio(prendasVisibles) {

    let mensaje = document.getElementById("sin-resultados");

    if (prendasVisibles === 0) {
        if (mensaje === null) {
            // Creo el mensaje la primera vez que hace falta
            mensaje = document.createElement("p");
            mensaje.id = "sin-resultados";
            mensaje.textContent = "No hay prendas con esas tallas.";
            document.querySelector(".vitrina").appendChild(mensaje);
        }
        mensaje.style.display = "block";
    } else {
        if (mensaje !== null) {
            mensaje.style.display = "none";
        }
    }
}

// ----- PASO 5: conectar cada casilla con la funcion -----
for (let m = 0; m < casillasTallas.length; m++) {
    casillasTallas[m].addEventListener("change", filtrarPorTallas);
}


// ===== BUSCADOR DE PRENDAS ===== EN CORRECTO FUNCIONAMIENTO
let cajaBusqueda = document.getElementById("buscar");

cajaBusqueda.addEventListener("input", function () {

    let texto = cajaBusqueda.value.toLowerCase();

    for (let i = 0; i < prendas.length; i++) {
        let titulo = prendas[i].querySelector("h3").textContent.toLowerCase();

        if (titulo.includes(texto)) {
            prendas[i].style.display = "";
        } else {
            prendas[i].style.display = "none";
        }
    }
});
// ===== FILTRO POR CATEGORIA ===== EN CORRECTO FUNCIONAMIENTO OKK. POR EL MOMENTO SOLO SE PUEDE VERIFICAR CON 6 ELEMENTOS POR FALTA DE MATERIAL VISUAL PARA SEGUIR CON LAS PRUEBAS
let enlacesCategoria = document.querySelectorAll(".grupo-categorias a[data-categoria]");

for (let i = 0; i < enlacesCategoria.length; i++) {
    enlacesCategoria[i].addEventListener("click", function (evento) {

        evento.preventDefault();   // evita que el enlace recargue la página

        let categoriaElegida = this.getAttribute("data-categoria");

        for (let j = 0; j < prendas.length; j++) {
            let categoriaPrenda = prendas[j].getAttribute("data-categoria");

            if (categoriaPrenda === categoriaElegida) {
                prendas[j].style.display = "";
            } else {
                prendas[j].style.display = "none";
            }
        }
    });
}
// ===== LIMPIAR TODOS LOS FILTROS ===== EN CORRECTO FUNCIONAMIENTO OKK
let btnLimpiar = document.getElementById("btn-limpiar");

btnLimpiar.addEventListener("click", function () {

    // 1. Desmarcar todas las casillas de talla
    for (let i = 0; i < casillasTallas.length; i++) {
        casillasTallas[i].checked = false;
    }

    // 2. Vacia el buscador
    cajaBusqueda.value = "";

    // 3. Mostrar todas las prendas
    for (let j = 0; j < prendas.length; j++) {
        prendas[j].style.display = "";
    }

    // 4. Ocultar el mensaje de "sin resultados"
    let mensaje = document.getElementById("sin-resultados");
    if (mensaje !== null) {
        mensaje.style.display = "none";
    }

    console.log("Filtros limpiados. Prendas visibles:", prendas.length); //HASTA AQUI TODO FUNCIONA CORRECTAMENTE
});