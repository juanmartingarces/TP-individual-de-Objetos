class Banda {
  const nombre

  method nombre() = nombre

  method presupuesto() = self.canon() + self.gastoExtra()

  method canon() = 1000000

  method gastoExtra()

  method popularidad()
}

class BandaRock inherits Banda {
  const solosDeGuitarra

  override method popularidad() = 100 * solosDeGuitarra

  override method gastoExtra() = 10000
}

class BandaTrap inherits Banda {
  const tieneHielo

  override method popularidad() = if (tieneHielo) 1000 else 0

  override method canon() = self.popularidad() * self.canonPorPuntoDePopularidad()

  method canonPorPuntoDePopularidad() = 1000000

  override method gastoExtra() = 0
}

class BandaIndie inherits Banda {
  const instrumentos = []

  override method popularidad() = 3.14 * nombre.length()

  override method gastoExtra() = instrumentos.size() * self.gastoPorInstrumento()

  method gastoPorInstrumento() = 500
}

class Entrada {
  const banda
  const fecha

  method precio() = self.precioBase() + productora.impuesto()

  method precioBase() = 1000

  method esDelAnio(unAnio) = fecha.year() == unAnio

  method esDeBanda(unaBanda) = banda == unaBanda

  method nombreDeBanda() = banda.nombre()
}

object abonoFan {
  method montoAPagar(unaEntrada) = unaEntrada.precio()

  method bonificar() { }
}

class AbonoVip {
  var porcentajeDescuento

  method montoAPagar(unaEntrada) = unaEntrada.precio() * (100 - porcentajeDescuento) / 100

  method bonificar() {
    porcentajeDescuento += 1
  }
}

class Asistente {
  var property abono
  var dinero
  const entradas = []

  method dinero() = dinero

  method cantidadDeEntradas() = entradas.size()

  method comprarEntrada(unaBanda, unaFecha) {
    self.validarSaldoPositivo()
    const entrada = new Entrada(banda = unaBanda, fecha = unaFecha)
    dinero -= self.montoAPagar(entrada)
    entradas.add(entrada)
  }

  method validarSaldoPositivo() {
    if (!self.tieneSaldoPositivo()) self.error("No hay saldo positivo")
  }

  method tieneSaldoPositivo() = dinero > 0

  method montoAPagar(unaEntrada) = abono.montoAPagar(unaEntrada)

  method bonificar() {
    abono.bonificar()
  }

  method entradasDelAnioAnterior() =
    entradas.filter({ entrada => entrada.esDelAnio(self.anioAnterior()) })

  method anioAnterior() = new Date().year() - 1

  method nombresDeBandasConEntrada() =
    entradas
      .map({ entrada => entrada.nombreDeBanda() })
      .asSet()

  method recaudacion() = entradas.sum({ entrada => entrada.precio() })

  method cantidadDeEntradasDe(unaBanda) =
    entradas.count({ entrada => entrada.esDeBanda(unaBanda) })
}
object productora {
  var property impuesto = 200
  const asistentes = []
  const bandas = []

  method agregarAsistente(unAsistente) {
    asistentes.add(unAsistente)
  }

  method agregarBanda(unaBanda) {
    bandas.add(unaBanda)
  }

  method gananciaTotal() = self.recaudacion() - self.presupuestoTotalDeBandas()

  method recaudacion() = asistentes.sum({ asistente => asistente.recaudacion() })

  method presupuestoTotalDeBandas() = bandas.sum({ banda => banda.presupuesto() })

  method cantidadDeEntradasVendidas() = asistentes.sum({ asistente => asistente.cantidadDeEntradas() })

  method bandaMasPopular() = bandas.max({ banda => self.entradasVendidasDe(banda) })

  method entradasVendidasDe(unaBanda) = asistentes.sum({ asistente => asistente.cantidadDeEntradasDe(unaBanda) })
}
