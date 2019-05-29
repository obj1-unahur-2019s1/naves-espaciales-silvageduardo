class NaveEspacial {
	var velocidad = 0
	var direccion = 0	
	var combustible = 0
	
	method velocidad(cuanto) { velocidad = cuanto }
	method acelerar(cuanto) { velocidad = (velocidad + cuanto).min(100000) }
	method desacelerar(cuanto) { velocidad = (velocidad - cuanto).max(0) }
	
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	
	method acercarseUnPocoAlSol() { direccion = (direccion + 1).max(10) }
	method alejarseUnPocoDelSol() { direccion = (direccion - 1).min(-10)}
	
	method cargarCombustible(cuanto){ combustible += cuanto}
	method descargarCombustible(cuanto){ combustible -= cuanto}
	
	method estaTranquila()= combustible >= 4000 and velocidad <= 12000
	
}

class NavesBaliza inherits NaveEspacial{
	const colores = ["verde","rojo","azul"]
	var colorBaliza 
	
	method cambiarColorDeBaliza(colorNuevo) { 
		colorBaliza = colores.find({ color => color == colorNuevo})
		return colorBaliza
		}
	
	
	method prepararViaje(){
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method escapar(){self.irHaciaElSol()}
	method avisar() = self.cambiarColorDeBaliza("rojo")
	
	method recibirAmenaza(){
		self.escapar()
		return self.avisar()
	}
	override method estaTranquila() = super() and colorBaliza !="rojo"
}

class NavesDePasajeros inherits NaveEspacial{
	var property pasajeros = 0
	var property racionesComida = 0
	var property racionesBebida = 0
	
	method prepararViaje(){
		racionesComida += pasajeros * 4 
		racionesBebida += pasajeros * 6
		self.acercarseUnPocoAlSol()
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method escapar(){velocidad*=2}
	method avisar(){
		racionesComida -= 1
		racionesBebida -= 2
	}
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
}

class NavesDeCombate inherits NaveEspacial{
	var property estaVisible = false
	var property misilesDesplegados = false
	var mensajes = []
	
	method ponerseVisible(){ estaVisible = true}
	method ponerseInvisible(){ estaVisible = false}
	method estaInvisible() = estaVisible
	
	method desplegarMisiles(){ misilesDesplegados = true}
	method replegarMisiles(){ misilesDesplegados = false}
	method misilesDesplegados() = misilesDesplegados
	
	method emitirMensaje(mensaje){	mensajes.add(mensaje) }
	method mensajesEmitidos() = mensajes
	method primerMensajeEmitido() = mensajes.first()
	method ultimoMensajeEmitido() = mensajes.last()
	method esEscueta() = not mensajes.any({ mensaje => mensaje.size()>30})
	method emitioMensaje(mensaje) = self.mensajesEmitidos().any({m => m.find(mensaje) })
	
	method prepararViaje(){
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
		self.cargarCombustible(30000)
		self.acelerar(5000)
		self.acelerar(15000)
	}
	method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	override method estaTranquila()= super() and not misilesDesplegados
	
}

class NaveHospital inherits NavesDePasajeros{
		
	var property quirofanoDisponible = false
	
	method quirofanoPreparado(){ quirofanoDisponible = true }
	method quirofanoNoPreparado(){ quirofanoDisponible = false }
		
	override method recibirAmenaza(){
		super()
		self.quirofanoPreparado()
	}
	
	override method estaTranquila()= super() and not quirofanoDisponible
}

class NaveDeCombateSigilosa inherits NavesDeCombate{
	
	
	override method escapar(){
		super()
		self.replegarMisiles()
		self.ponerseInvisible()
	}
	override method estaTranquila()= super() and estaVisible
}