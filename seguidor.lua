-- lua
-- marcow 17/07/24

function sysCall_init() -- inicializacao da biblioteca 'sim' e dos componentes em cena

  sim = require("sim")
  motoresquerdo = sim.getObject("./motoresquerdo")
  motordireito = sim.getObject("./motordireito")
  sensores = {-1, -1} -- sensores de visao 
  sensores[1] = sim.getObject("./sensoresquerdo")
  sensores[2] = sim.getObject("./sensordireito")
  velocidade = 10 -- velocidade do robo -- feat: adicionar velocidade em radianos
  
end

function sysCall_actuation() -- loop

  leiturasensores = {false, false} 
  
  for i = 1, 2 do -- executa pra n sensores
      verificar, dados = sim.readVisionSensor(sensores[i]) -- realiza a leitura do sensor[n]
      
      if verificar > -1 then -- caso exista uma leitura 
          leiturasensores[i] = (dados[1] < 0.33) -- verifica se a leitura corresponde a cor preta
          -- print(leiturasensores[i])
      end
  end
  
  velocidadedireito = velocidade
  velocidadeesquerdo = velocidade

  if leiturasensores[1] then -- diminiu a velocidade do motor esquerdo se o sensor esquerdo for true
      velocidadeesquerdo = velocidade * 0.1
  end
  
  if leiturasensores[2] then -- diminiu a velocidade do motor direito se o sensor direito for true
      velocidadedireito = velocidade * 0.1
  end
  
  -- apos definir a valor da velocidade de cada motor 
  -- os mesmos sao ativos 
  
  sim.setJointTargetVelocity(motordireito, velocidadedireito)
  sim.setJointTargetVelocity(motoresquerdo, velocidadeesquerdo)
  
end