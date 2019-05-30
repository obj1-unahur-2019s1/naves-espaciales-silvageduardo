class NaveEspacial {
	var velocidad = 0
	var direccion = 0	
	var combustible = 0
	
	method velocidad(cuanto) { velocidad = cuanto }
	method acelerar(cuanto) { velocidad = (velocidad + cuanto).min(100000) }
	method desacelerar(cuanto) { velocidad = (velocidad - cuanto).max(0) }
	method mostrarVelocidad()=return velocidad
	
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	
	method acercarseUnPocoAlSol() { direccion = (direccion + 1).max(10) }
	method alejarseUnPocoDelSol() { direccion = (direccion - 1).min(-10)}
	
	method cargarCombustible(cuanto){ combustible += cuanto}
	method descargarCombustible(cuanto){ combustible -= cuanto}
	method cantidadCombustible()=return combustible
	
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method escapar()
	method avisar()
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	
	method estaTranquila()= combustible >= 4000 and velocidad <= 12000
	
}

class NavesBaliza inherits NaveEspacial{
	const colores = ["verde","rojo","azul"]
	var property colorBaliza 
	
	method cambiarColorDeBaliza(colorNuevo) { 
		colorBaliza = colores.find({ color => color == colorNuevo})
		}
	
	
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method escapar(){self.irHaciaElSol()}
	override method avisar() { self.cambiarColorDeBaliza("rojo")
		return colorBaliza
	}
	override method estaTranquila() = super() and colorBaliza !="rojo"
}

class NavesDePasajeros inherits NaveEspacial{
	var property pasajeros = 0
	var property racionesComida = 0
	var property racionesBebida = 0
	
	method cargarRacionesDeComida(cuanto){racionesComida+=cuanto }
	method descargarRacionesDeComida(cuanto){racionesComida-=cuanto }
	method cargarRacionesDeBebida(cuanto){racionesBebida+=cuanto }
	method descargarRacionesDeBebida(cuanto){racionesBebida-=cuanto }
	
	override method prepararViaje(){
		super()
		racionesComida += pasajeros * 4 
		racionesBebida += pasajeros * 6
		self.acercarseUnPocoAlSol()

	}
	override method escapar(){self.acelerar(velocidad)}
	override method avisar(){
		self.descargarRacionesDeComida( pasajeros )
		self.descargarRacionesDeBebida( pasajeros )
		self.descargarRacionesDeBebida( pasajeros )
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
	method emitioMensaje(mensaje) = self.mensajesEmitidos().contains(mensaje)
	
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
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
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
	override method estaTranquila()= super() and estaVisible
}