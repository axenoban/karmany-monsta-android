# Instrucciones de desarrollo de Karmany Monsta

Antes de iniciar cualquier desarrollo, ajuste o actualización, leer `docs/CONTINUIDAD.md` completo y los documentos que indique para el bloque actual. Verificar ramas, commits, cambios locales y CI reales antes de editar. Esta lectura es obligatoria, especialmente antes de cambios grandes.

Al terminar cada mejora actualizar `docs/CONTINUIDAD.md`: implementación, rama, pruebas ejecutadas, validación pendiente, limitaciones y siguiente paso concreto si el creador confirma «prueba correcta». Actualizarlo también ante interrupciones o cambios de alcance. No afirmar resultados aún no comprobados.

«Prueba correcta» permite cerrar el bloque e integrar por fast-forward en `dev/karmany-core`, sin force push. `main` se reserva para publicación. Trabajar en `feature/*` para bloques no validados. Conservar guardados y reglas aprobadas; no inventar canon, balance o economía. Si el siguiente bloque requiere decisiones nuevas, preparar preguntas concretas antes de implementarlo.

Las instrucciones del usuario tienen prioridad. No es necesario recuperar el chat anterior si este documento y el estado real del repositorio proporcionan el contexto suficiente.
