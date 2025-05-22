// 1. Rutinas
class Rutina {
  const property intensidad
  
  method tiempoDeDescanso(tiempo)
  
  method caloriasQuemadas(tiempo) = (100 * (tiempo - self.tiempoDeDescanso(
    tiempo
  ))) * intensidad
}

class Running inherits Rutina {
  override method tiempoDeDescanso(tiempo) {
    if (tiempo > 20) {
      return 5
    } else {
      return 2
    }
  }
}

class Maraton inherits Running {
  override method caloriasQuemadas(tiempo) = super(tiempo) * 2
}

class Remo inherits Rutina (intensidad = 1.3) {
  override method tiempoDeDescanso(tiempo) = tiempo / 5
}

class RemoCompetitivo inherits Remo (intensidad = 1.7) {
  override method tiempoDeDescanso(tiempo) = (super(tiempo) - 3).max(2)
} // - - - - - - - - - - - - - - - - - //

// 2. Personas
class Persona {
  var property peso
  const property tiempoDeEjercicio
  const property kilosPorCaloria
  
  method puedeRealizar(rutina)

  method cuantasCaloriasQuemaCon(rutina) = rutina.caloriasQuemadas(tiempoDeEjercicio)
  
  method pesoPerdido(rutina) = self.cuantasCaloriasQuemaCon(
    rutina
  ) / kilosPorCaloria
  
  method bajarPeso(rutina) {
    if (self.puedeRealizar(rutina)) {
      peso -= self.pesoPerdido(rutina)
    }
  }
}

class PersonaSedentaria inherits Persona (kilosPorCaloria = 7000) {
  override method puedeRealizar(rutina) = peso > 50
}

class PersonaAtleta inherits Persona (
  tiempoDeEjercicio = 90,
  kilosPorCaloria = 8000
) {
  override method puedeRealizar(rutina) = self.cuantasCaloriasQuemaCon(
    rutina
  ) > 10000
  
  override method bajarPeso(rutina) {
    if (self.puedeRealizar(rutina)) {
      peso -= self.pesoPerdido(rutina) - 1
    }
  }
} // - - - - - - - - - - - - - - - - - //

// 3. Clubes
class Club {
  const property predios = #{}
  
  method mejorPredioPara(persona) = predios.max(
    { pred => pred.caloriasQuemadasEnTotalPor(persona) }
  )
  
  method prediosTranquisPara(persona) = predios.filter(
    { pred => pred.esUnPredioTranquiPara(persona) }
  )
  
  method rutinasMasExigentesDelClubPara(persona) = predios.map(
    { pred => pred.rutinaMasExigenteDelPredioPara(persona) }
  )
}

class Predio {
  const property rutinas = []
  
  method caloriasQuemadasEnTotalPor(persona) = rutinas.fold(
    0,
    { total, rut => persona.cuantasCaloriasQuemaCon(rut) + total }
  )
  
  method rutinaMasExigenteDelPredioPara(persona) = rutinas.max(
    { rut => persona.cuantasCaloriasQuemaCon(rut) }
  )
  
  method esUnPredioTranquiPara(persona) = rutinas.any(
    { rut => persona.cuantasCaloriasQuemaCon(rut) < 500 }
  )
}