# Integración controlada · Preview104 validada

**Fecha:** 15/11/2026 (UTC, integración técnica posterior a aprobación local del usuario el 14/11).

**Aprobación:** «ok integra esta version , valido esta opcion por el momento». Se registra como aprobación del estado visual y funcional conjunto de **Preview104**, no como verificación física desglosada de cada PR previo.

**Origen:** `feature/ui-integral-jade-exploracion-combate` @ `4a96bf3e18ce58cd5b6b8786b23fd598ded00f6e`; PR30; release `android-preview-104`; CI `43661494124` success. **Destino:** `dev/karmany-core` @ `a0e108c1ca8e908942492f18caa2ac2eab3fbb88` antes del cierre.

**Divergencia real:** el merge-base era `29be7ba3d30ea72e860f62ec4f0c8aa766e6d1b4`. Dev agregó PR29 (cinco skills) después de la bifurcación; la candidata incorporó las mismas skills por copia, con contenido SHA idéntico, pero no tenía el commit como ancestro.

**Estrategia:** commit de conciliación sin reescritura, padres en orden dev + Preview104, árbol del código de Preview104 y complementos documentales de PR29. Solo se añaden/modifican documentos de estado a la snapshot aprobada. La rama temporal `feature/integration-preview104-into-dev` se valida por Actions antes de mover dev por fast-forward con SHA esperado.

**Exclusiones:** No incorporar el kit PR24 (401 SVG, no aprobado); no iniciar E6, R2–R4 ni editar `main`. La aprobación corresponde al paquete completo que se ejecuta en Preview104; no se asume aprobación separada de propuestas de diseño no incorporadas.

**Pruebas exigidas:** igualdad de archivos jugables de candidata y merge, `ci/validate_skills.py`, Godot import/tests, CI completa y APK; después auditar HEAD e historia y dejar `main` intacta.

**Cierre:** registrar resultado de la integración y SHA final únicamente después de confirmar el avance remoto a dev. Un CI correcto no equivale a aprobación artística de futuros recursos.

## Cierre remoto verificado · 15/11/2026

- **Integrado realmente** en `dev/karmany-core` mediante fast-forward sin force del SHA `a0e108c1` al merge `3a5f53384c9dd958ca786e27ed89adf7c7b993f2`. Contiene de forma trazable las dos historias de PR29 skills y Preview104, sin alterar el juego respecto a la APK aprobada.
- **Pruebas**: [GitHub Actions 43662842572](https://github.com/axenoban/karmany-monsta-android/actions/runs/43662842572) success; APK Android exportada. No atribuir pruebas físicas adicionales a la frase de aprobación del usuario.
- **GitHub**: PR21 y PR31 `merged=true`; PR22,23,25,27,28,30 cerrados por inclusión indirecta con comentarios que señalan el commit responsable; PR24 (401 SVG no aprobados) y PR26 (documental independiente) conservados abiertos.
- **Protección**: `main` en `9ef7af778ee59a47f62bdfbfd5eb0786ce787213`, no se modificó. La presente actualización de cierre modifica exclusivamente documentación.
- **Próxima etapa**: validar recursos visuales definitivos por familia; ningún nuevo kit se considera aprobado por este cierre.
