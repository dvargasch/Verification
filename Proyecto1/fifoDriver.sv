/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////Esta clase corresponde a la fifo emulada para el driver/////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

class fifo_entrada #(parameter terminales=4, parameter ancho_pal = 32);//se necesita parametrizar la cantidad de terminales o drivers y el ancho de la palabra que ingresara
  bit pop; //para simular la funcion del pop que es eliminar el elemento del frente
  bit pndng;//indica si hay datos pendientes
  bit [ancho_pal-1:0] D_pop;//el dato extraido de la fifo
  
  bit [ancho_pal-1:0] queue [$];//para simular la FIFO
  
  int identificador;//identificador
  
  virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) vif;//interfaz virtual
  
  //constructor:para crear objetos nyuevos de la clase fifo_entrada
  function new(int identify);
    this.pop = 0;  
    this.pndng = 0;
    this.D_pop = 0;
    this.queue = {};//vacia porque es array
    this.identificador = identify;
  endfunction 
  
  task pop_(); //se encarga de realizar "pop" en la fifo
    forever begin
      @(negedge vif.clk);//espera al flanco negativo del reloj en la interfaz virtual vif
      vif.pndng[0][identificador] = pndng; //actualiza el valor de pending en la interfaz virtual vif
      pop = vif.pop[0][identificador];//copia el valor del pop desde la interfaz virtual vif
    end
  endtask
  
  task Dout_uptate(); // actualiza la fifo
    forever begin
      @(posedge vif.clk);//espera al flanco positivo del reloj en la interfaz virtual vif
      vif.D_pop[0][identificador] = queue[0]; // actualiza el valor del dato extraido
      if(pop ==1) begin
        queue.pop_front(); //Elimina el elemento del frente 
      end 
      if (queue.size ==0)begin //si el tamaño de la queue (fifo) es 0 implica que no hay dato pendiente que enviar
        pndng = 0;//se actualiza el valor del pending
      end
    end
  endtask
  
  function void push_(bit [ancho_pal-1:0] dato); //se encarga de realizar "push" en la fifo
    queue.push_back(dato);    //Ingresa el dato en la fifo
    pndng = 1;  //actualiza el valor de pending a 1
  endfunction
endclass