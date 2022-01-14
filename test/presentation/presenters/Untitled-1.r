

function convocarMedicoElegivel(medicoID){
   
    medico = getMedico(medicoID);

    if (medico.COVID = TRUE AND medico.SAUDE < 100% AND medico.VACINADO){
        medico.STATUS = ELEGIVEL;
        medico.MENSAGEM = "Apto para salvar vidas"; 
    }elseif (medico.COVID = FALSE AND medico.SAUDE = 100% AND medico.NAO_VACINADO){
        medico.STATUS = FORA;
        medico.MENSAGEM = "Inapto para salvar vidas"; 
    }

    if (medico.STATUS = ELEGIVEL){
        return medico;
    }else{
        return NULL;
    }

}