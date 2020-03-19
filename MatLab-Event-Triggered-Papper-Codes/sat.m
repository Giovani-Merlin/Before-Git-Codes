function out = sat(u,satu)
    
    if(u < -satu)
        out =  -satu;
        return
    
    elseif (u > satu)
        out = satu;
        return
        
     end
        
            
     
     out = u;
     return
   
	
	end
