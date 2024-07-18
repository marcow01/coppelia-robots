-- lua
-- marcow 17/07/24

function sysCall_init() -- inicializacao da biblioteca 'sim' e dos componentes em cena

  sim = require('sim')
  motoresquerdo = sim.getObject('./motoresquerdo')
  motordireito = sim.getObject('./motordireito')
  sensorproximidade = {} -- sensores de proximidade
  sensorproximidade[1] = sim.getObject('./central')
  sensorproximidade[2] = sim.getObject('./esquerda')
  sensorproximidade[3] = sim.getObject('./direita')
  velocidade = 10 -- velocidade do robo -- feat: adicionar velocidade em radianos
  distanciasensores = {0, 0, 0} -- distancia em metros do objeto detectado
  
end

function sysCall_sensing() -- utilizado pra realizar a leitura dos sensores presentes no robo
  
  for i = 1, 3 do -- executa pra n sensores
      
      -- executa a inicializacao do sensor[n] 
      verificador, distancia, coordenadas = sim.handleProximitySensor(sensorproximidade[i])
      
      if verificador > 0 then -- caso exista uma leitura
      
          -- atribui a leitura do sensorproximidade[n] ao distanciasensores[n]
          distanciasensores[i] = distancia
          --print(i, distancia)
          
      end
  end
  
  
end

function sysCall_actuation() -- loop
  
  menordistancia = 1 -- o valor dessa variavel sera mudado de acordo com a comparacao entre o valor lido pelo sensor e o seu valor atual
  indice = -1 -- esse indice indica qual sensor possui a leitura de menor distancia

  for i = 1, 3 do 
      if distanciasensores[i] > 0 and distanciasensores[i] < menordistancia then 
          -- caso a leitura do sensor seja maior que 0 
          -- e menor que a menor distancia
          -- o mesmo vai se tornar a menor distancia atual
          menordistancia = distanciasensores[i]
          indice = i -- indice do sensor da menor distancia 
      end
  end

  if indice == 1 then -- sensor central -- ambos os motores sao ativos

      sim.setJointTargetVelocity(motoresquerdo, velocidade)
      sim.setJointTargetVelocity(motordireito, velocidade)
      
  elseif indice == 2 then -- sensor esquerdo -- motor esquerdo diminui a velocidade

      sim.setJointTargetVelocity(motoresquerdo, velocidade * 0.5)
      sim.setJointTargetVelocity(motordireito, velocidade)
      
  elseif indice == 3 then -- sensor direito -- motor direito diminui a velocidade
      
      sim.setJointTargetVelocity(motoresquerdo, velocidade)
      sim.setJointTargetVelocity(motordireito, velocidade * 0.5)
      
  else -- caso nao haja nenhuma deteccao o sumo gira em circulo para procurar algo
      
      sim.setJointTargetVelocity(motoresquerdo, velocidade)
      sim.setJointTargetVelocity(motordireito, -velocidade)
      
  end
  
end
