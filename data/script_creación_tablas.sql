/*
Script de creacion inicial
*/

USE [GD2C2016]
GO

CREATE SCHEMA [pico_y_pala] AUTHORIZATION [gd]
GO


create table pico_y_pala.funcionalidad 
(
	fun_id int identity (1,1)
	,fun_desc varchar (100)
	,constraint PK_fun_id primary key (fun_id)
);

create table pico_y_pala.rol
(
	rol_id int identity (1,1)
	,rol_nombre varchar (50)
	,rol_habilitado bit
	,constraint PL_rol_id primary key (rol_id)
);

create table pico_y_pala.rol_funcionalidad
(
	rfu_rol_id int
	,rfu_fun_id int 
	,constraint PK_rol_funcionalidad primary key (rfu_rol_id,rfu_fun_id)
	,constraint FK_rfu_rol_id foreign key (rfu_rol_id) references pico_y_pala.rol (rol_id)
	,constraint FK_rfu_fun_id foreign key (rfu_fun_id) references pico_y_pala.funcionalidad(fun_id)
);

create table pico_y_pala.usuario
(
	usu_username varchar (50) 
	,usu_nro_doc numeric (18,0) unique
	,usu_password varchar (64) 
	,usu_nombre varchar (255)
	,usu_apellido varchar (255)
	,usu_tipo_doc varchar (3)
	,usu_direccion varchar (255)
	,usu_telefono numeric (18,0)
	,usu_mail varchar (255)
	,usu_fecha_nac datetime
	,usu_sexo char (1)
	,usu_habilitado bit
	,usu_intentos_fallidos int
	,constraint PK_usu_username primary key (usu_username)
);

create table pico_y_pala.rol_usuario
(
	rus_rol_id int 
	,rus_usu_username varchar (50) 
	,constraint PK_rol_usuario primary key (rus_rol_id,rus_usu_username)
	,constraint FK_rus_usu_username foreign key (rus_usu_username) references pico_y_pala.usuario(usu_username)
	,constraint FK_rus_fun_id foreign key (rus_rol_id) references pico_y_pala.rol (rol_id)
);

create table pico_y_pala.profesional 
(
	pro_nro_doc numeric (18,0) 
	,pro_matricula numeric (18,0) identity (1,1)
	,constraint PK_pro_nro_doc primary key (pro_nro_doc)
	,constraint FK_pro_nro_doc foreign key (pro_nro_doc) references pico_y_pala.usuario(usu_nro_doc)
);

create table pico_y_pala.tipo_especialidad
(
	tes_id int
	,tes_desc varchar(255)
	constraint tes_id primary key (tes_id)
);

create table pico_y_pala.especialidad
(
	esp_id int
	,esp_desc varchar (255)
	,esp_tes_id int 
	,constraint PK_esp_id primary key (esp_id)
	,constraint FK_esp_tes_id foreign key (esp_tes_id) references pico_y_pala.tipo_especialidad(tes_id),
);

create table pico_y_pala.profesional_especialidad
(
	pes_pro_nro_doc numeric (18,0) 
	,pes_esp_id int 
	,constraint PK_profesional_especialidad primary key (pes_pro_nro_doc, pes_esp_id)
	,constraint FK_pes_pro_nro_doc foreign key (pes_pro_nro_doc) references pico_y_pala.profesional(pro_nro_doc)
	,constraint FK_pes_esp_id foreign key (pes_esp_id) references pico_y_pala.especialidad (esp_id)
);

create table pico_y_pala.agenda
(
	--age_id numeric (18,0) identity (1,1)
	age_pro_nro_doc numeric (18,0)
	,age_esp_id int
	--,constraint PK_agenda primary key (age_id,age_pro_nro_doc,age_esp_id)
	,constraint PK_agenda primary key (age_pro_nro_doc,age_esp_id)
	,constraint FK_agenda foreign key (age_pro_nro_doc,age_esp_id) references pico_y_pala.profesional_especialidad (pes_pro_nro_doc,pes_esp_id)
);

create table pico_y_pala.dia
(
	dia_id int --identity (1,1)
	,dia_nombre char (10)
	,constraint PK_dia_id primary key (dia_id)
);

create table pico_y_pala.dia_por_agenda
(
	dpa_pro_nro_doc numeric (18,0)
	--,dpa_age_id numeric (18,0)
	,dpa_esp_id int
	,dpa_dia int 
	--,dpa_deste datetime
	--,dpa_hasta datetime
	,dpa_desde int
	,dpa_hasta int
	,constraint PK_dia_por_agenda primary key (dpa_pro_nro_doc,dpa_esp_id,dpa_dia)
	--,constraint FK_dia_por_agenda foreign key (dpa_age_id,dpa_pro_nro_doc,dpa_esp_id) references pico_y_pala.agenda (age_id,age_pro_nro_doc,age_esp_id)
	,constraint FK_dia_por_agenda foreign key (dpa_pro_nro_doc,dpa_esp_id) references pico_y_pala.agenda (age_pro_nro_doc,age_esp_id)
	,constraint FK_dpa_dia foreign key (dpa_dia) references pico_y_pala.dia (dia_id)
);

create table pico_y_pala.estado_civil
(
	eci_id int identity (1,1)
	,eci_desc varchar (100)
	,constraint PK_eci_id primary key (eci_id)
);

create table pico_y_pala.planes
(
	--pla_id numeric (18,0)
	pla_codigo numeric (18,0)
	,pla_desc varchar (100)
	,pla_precio_consulta numeric (18,0)
	,pla_precio_farmacia numeric (18,0) 
	constraint UNIQUE_pla_precio unique (pla_precio_consulta,pla_precio_farmacia),
	constraint PK_pla_id primary key (pla_codigo)
);

create table pico_y_pala.grupo_familiar
(
	gpo_id numeric (18,0) identity (1,1)
	,gpo_titular numeric (18,0)
	,constraint PL_gpo_id primary key (gpo_id) 
);

create table pico_y_pala.afiliado
(
	afi_nro_doc numeric (18,0) 
	,afi_nro_afiliado numeric (18,0) unique
	,afi_eci_id int  
	,afi_pla_codigo numeric (18,0)
	,afi_nro_consulta numeric (18,0)
	,afi_activo bit
	,afi_fecha_baja datetime 
	,constraint PK_afi_nro_doc primary key (afi_nro_doc)
	,constraint FK_afi_nro_doc foreign key (afi_nro_doc) references pico_y_pala.usuario(usu_nro_doc)
	,constraint FK_afi_eci_id foreign key (afi_eci_id) references pico_y_pala.estado_civil (eci_id)
	,constraint FK_afi_pla_id foreign key (afi_pla_codigo) references pico_y_pala.planes (pla_codigo)
)

create table pico_y_pala.gf_afiliado
(
	agf_gpo_id numeric (18,0)
	,agf_afi_nro_doc numeric (18,0) 
	,constraint PK_gf_afiliado primary key (agf_gpo_id,agf_afi_nro_doc)
	,constraint FK_agf_gpo_id foreign key (agf_gpo_id) references pico_y_pala.grupo_familiar (gpo_id)
	,constraint FK_agf_afi_nro_doc foreign key (agf_afi_nro_doc) references pico_y_pala.afiliado (afi_nro_doc)
)

alter table pico_y_pala.grupo_familiar 
add constraint FK_gpo_afi foreign key (gpo_titular) references pico_y_pala.afiliado (afi_nro_doc)

create table pico_y_pala.audit_cambio_plan
(
	acp_id numeric (18,0) identity (1,1)
	,acp_afiliado numeric (18,0) 
	,acp_fecha datetime
	,acp_motivo varchar (255)
	,acp_plan_anterior numeric (18,0)
	,acp_plan_nuevo numeric (18,0) 
	,constraint PK_acp_id primary key (acp_id)
	,constraint FK_acp_afiliado foreign key (acp_afiliado) references pico_y_pala.afiliado (afi_nro_doc)
	,constraint FK_acp_plan_anterior foreign key (acp_plan_anterior) references pico_y_pala.planes (pla_codigo)
	,constraint FK_acp_plan_nuevo foreign key (acp_plan_nuevo) references pico_y_pala.planes (pla_codigo)
);

create table pico_y_pala.tipo_cancelacion
(
	tca_id int identity (1,1)
	,tca_desc varchar (255)
	,constraint PK_tca_id primary key (tca_id)
);

create table pico_y_pala.cancelacion
(
	can_id numeric (18,0) identity (1,1)
	,can_tca_id int
	,can_motivo varchar (255)
	,constraint PK_can_id primary key (can_id)
	,constraint FK_can_tca_id foreign key (can_tca_id) references pico_y_pala.tipo_cancelacion (tca_id)
);

create table pico_y_pala.compra
(
	com_id numeric (18,0) identity (1,1)
	,com_afi_compro numeric (18,0)
	,com_cant numeric (18,0)
	,com_precio numeric (18,0)
	,com_fecha datetime
	,constraint PK_com_id primary key (com_id)
	,constraint FK_com_afi_compro foreign key (com_afi_compro) references pico_y_pala.afiliado (afi_nro_doc)
);

create table pico_y_pala.bono
(
	bon_id numeric (18,0) identity
	,bon_afiliado_compra numeric (18,0) 
	,bon_pla_id numeric (18,0) 
	,bon_nro_consultas_afiliado numeric (18,0)
	,bon_afiliado_utilizo numeric (18,0) 
	,bon_fecha_utilizo datetime
	,bon_com_id numeric (18,0) 
	,constraint PK_bon_id primary key (bon_id)
	,constraint FK_bon_afiliado_compra foreign key (bon_afiliado_compra) references pico_y_pala.afiliado (afi_nro_doc)
	,constraint FK_bon_pla_id foreign key (bon_pla_id) references pico_y_pala.planes (pla_codigo)
	,constraint FK_bon_afiliado_utilizo foreign key (bon_afiliado_utilizo) references pico_y_pala.afiliado (afi_nro_doc)
	,constraint FK_bon_com_id foreign key (bon_com_id) references pico_y_pala.compra (com_id)
);

create table pico_y_pala.turno
(
	tur_id numeric (18,0)
	,tur_afi_nro_doc numeric (18,0) 
	,tur_pro_nro_doc numeric (18,0) 
	,tur_fecha_hora datetime
	,tur_can_id numeric (18,0) 
	,constraint PK_tur_id primary key (tur_id)
	,constraint FK_tur_afi_username foreign key (tur_afi_nro_doc) references pico_y_pala.afiliado (afi_nro_doc)
	,constraint FK_tur_pro_username foreign key (tur_pro_nro_doc) references pico_y_pala.profesional (pro_nro_doc)
);

create table pico_y_pala.consulta
(
	con_id numeric (18,0) identity (1,1)
	,con_tur_id numeric (18,0) 
	,con_bono_utilizado numeric (18,0)
	,con_fecha_llegada datetime
	,con_fecha_consulta datetime
	,constraint PK_con_id primary key (con_id)
	,constraint FK_con_tur_id foreign key (con_tur_id) references pico_y_pala.turno (tur_id)
	,constraint FK_con_bono_utilizado foreign key (con_bono_utilizado)references pico_y_pala.bono (bon_id)
);

create table pico_y_pala.sintoma
(
	sin_id numeric (18,0) identity (1,1)
	,sin_desc varchar (255)	
	,constraint PK_sin_id primary key (sin_id)
);

create table pico_y_pala.consulta_sintoma
(
	csi_con_id numeric (18,0) 
	,csi_sin_id numeric (18,0) 
	,constraint PK_consulta_sintoma primary key (csi_con_id,csi_sin_id)
	,constraint FK_csi_con_id foreign key (csi_con_id) references pico_y_pala.consulta (con_id)
	,constraint FK_csi_sin_id foreign key (csi_sin_id) references pico_y_pala.sintoma (sin_id)
);

create table pico_y_pala.enfermedad
(
	enf_id numeric (18,0) identity (1,1)
	,enf_desc varchar (255)	
	,constraint PK_enf_id primary key (enf_id)
);

create table pico_y_pala.consulta_enfermedad
(
	cen_con_id numeric (18,0) 
	,cen_enf_id numeric (18,0) 
	,constraint PK_consulta_enfermedad primary key (cen_con_id,cen_enf_id)
	,constraint FK_cen_con_id foreign key (cen_con_id) references pico_y_pala.consulta (con_id)
	,constraint FK_cen_sin_id foreign key (cen_enf_id) references pico_y_pala.enfermedad (enf_id)
);
GO
--STORE PROCEDURES

CREATE PROCEDURE PICO_Y_PALA.checkLoginAndUpdateFailures(@user VARCHAR(50), @pass VARCHAR(64), @ok BIT OUTPUT, @enabled BIT OUTPUT)
AS
BEGIN
	DECLARE @passReal VARCHAR(64), @intentosFallidos TINYINT;
	SET @ok = 0;
	SELECT @passReal=usu_password, @enabled=usu_habilitado, @intentosFallidos=usu_intentos_fallidos FROM PICO_Y_PALA.usuario WHERE USU_USERNAME=@user;
	IF @passReal IS NOT NULL AND @passReal <> ''
		BEGIN
			IF @enabled = 1
				BEGIN
					IF @passReal=@pass
						BEGIN
							SET @ok=1;
							UPDATE PICO_Y_PALA.usuario SET usu_intentos_fallidos=0 WHERE usu_username=@user;
						END
					ELSE
						BEGIN
							IF @intentosFallidos=2
								BEGIN
									UPDATE PICO_Y_PALA.usuario SET usu_habilitado=0 WHERE usu_username=@user;
									SET @enabled=0;
								END;
							UPDATE PICO_Y_PALA.usuario SET usu_intentos_fallidos=@intentosFallidos+1 WHERE usu_username=@user;
						END
				END
		END
	ELSE
		SET @enabled = 1 --Si entra por esta rama, no existe el usuario. Se devuelve por defecto enabled=true
END;
GO

--Crea un rol y lo relaciona con la funcionalidad base de Login
CREATE PROCEDURE PICO_Y_PALA.crearRol (@rol_nombre VARCHAR(255))
AS
BEGIN
	IF exists (SELECT * FROM PICO_Y_PALA.rol WHERE rol_nombre=@rol_nombre)
	BEGIN
		RAISERROR('Ya hay un rol con el nombre solicitado',16,1)
		RETURN
	END
	INSERT INTO PICO_Y_PALA.rol(rol_habilitado,rol_nombre) VALUES (1,@rol_nombre)
	INSERT INTO PICO_Y_PALA.rol_funcionalidad(rfu_fun_id,rfu_rol_id) VALUES (1,(SELECT rol_id FROM PICO_Y_PALA.rol WHERE rol_nombre = @rol_nombre));
END
GO

--Crea un asociacion rol_funcionalidad
CREATE PROCEDURE PICO_Y_PALA.crearRolFuncionalidad (@rol_nombre VARCHAR(255), @fun_nombre VARCHAR(255))
AS
BEGIN
	DECLARE @rol_id INT, @fun_id INT,@message VARCHAR(255)
	SELECT @rol_id = rol_id FROM PICO_Y_PALA.rol WHERE rol_nombre = @rol_nombre
	SELECT @fun_id = fun_id FROM PICO_Y_PALA.funcionalidad WHERE fun_desc = @fun_nombre
	INSERT INTO PICO_Y_PALA.rol_funcionalidad(rfu_fun_id,rfu_rol_id) VALUES (@fun_id,@rol_id)
END
GO

CREATE PROCEDURE PICO_Y_PALA.borrarRolFuncionalidad (@rol_nombre VARCHAR(255), @fun_nombre VARCHAR(255))
AS
BEGIN
	DECLARE @rol_id INT, @fun_id INT,@message VARCHAR(255)
	SELECT @rol_id = rol_id FROM PICO_Y_PALA.rol WHERE rol_nombre = @rol_nombre
	SELECT @fun_id = fun_id FROM PICO_Y_PALA.funcionalidad WHERE fun_desc = @fun_nombre
	DELETE FROM PICO_Y_PALA.rol_funcionalidad WHERE rfu_fun_id = @fun_id AND rfu_rol_id = @rol_id
END
GO

CREATE PROCEDURE PICO_Y_PALA.deshabilitarRol (@idRol INT)
AS
BEGIN
	UPDATE PICO_Y_PALA.rol SET rol_habilitado=0 WHERE rol_id = @idRol;
	DELETE FROM PICO_Y_PALA.rol_usuario WHERE rus_rol_id = @idRol;
END
GO

CREATE PROCEDURE PICO_Y_PALA.habilitarRol (@idRol INT)
AS
BEGIN
	UPDATE PICO_Y_PALA.rol SET rol_habilitado=1 WHERE rol_id = @idRol;
END
GO

CREATE PROCEDURE PICO_Y_PALA.cambiarNombreRol (@idRol INT, @rol_nombre_nuevo VARCHAR(255))
AS
BEGIN
	UPDATE PICO_Y_PALA.rol SET rol_nombre=@rol_nombre_nuevo WHERE rol_id = @idRol;
END
GO

CREATE PROCEDURE PICO_Y_PALA.altaAfiliado (@afi_nroAfi numeric(18,0), @afi_username VARCHAR(50),@afi_nro_doc numeric(18,0),@afi_password varchar(64) ,@afi_nombre varchar(255),@afi_apellido varchar(255),@afi_tipo_doc varchar(3),@afi_direccion varchar(255),@afi_telefono numeric(18,0),@afi_mail varchar(255),@afi_fecha_nac datetime,@afi_sexo char(1), @afi_plan varchar(255), @afi_eci varchar (100))
AS
BEGIN
	DECLARE @afi_planID NUMERIC (18,0), @afi_eciID INT,@afi_gfID NUMERIC (18,0)
	SELECT @afi_planID = pla_codigo FROM PICO_Y_PALA.planes WHERE pla_desc = @afi_plan
	SELECT @afi_eciID = eci_id FROM PICO_Y_PALA.estado_civil WHERE eci_desc = @afi_eci
	IF exists (SELECT * FROM PICO_Y_PALA.usuario WHERE usu_nro_doc=@afi_nro_doc)
	BEGIN
		RAISERROR('Ya hay un usuario con el Documento Ingresado',16,1)
		RETURN
	END
	IF exists (SELECT * FROM PICO_Y_PALA.usuario WHERE usu_username=@afi_username)
	BEGIN
		RAISERROR('Ya existe el nombre de usuario ingresado',16,1)
		RETURN
	END
--Creo el Usuario
	insert into pico_y_pala.usuario
	(usu_username,usu_nro_doc,usu_password,usu_apellido,usu_nombre,usu_tipo_doc,usu_direccion,usu_telefono,usu_mail,usu_fecha_nac,usu_sexo,usu_habilitado,usu_intentos_fallidos)
	values (@afi_username,@afi_nro_doc,@afi_password,@afi_apellido,@afi_nombre,@afi_tipo_doc,@afi_direccion,@afi_telefono,@afi_mail,@afi_fecha_nac,@afi_sexo,1,0)
--Asigno Rol a usuario
	insert into pico_y_pala.rol_usuario
	(rus_rol_id,rus_usu_username)
	values(3,@afi_username)
--Creo el Afiliado 
	insert into pico_y_pala.afiliado
	(afi_nro_doc,afi_nro_afiliado,afi_eci_id,afi_pla_codigo,afi_nro_consulta,afi_activo,afi_fecha_baja) 
	values (@afi_nro_doc,@afi_nroAfi,@afi_eciID,@afi_planID,0,1,null)
--Creo el Grupo Familiar como Titular
	insert into pico_y_pala.grupo_familiar
	(gpo_titular)
	values(@afi_nro_doc)
--Asocio el Grupo Familiar con el Afiliado
	SELECT @afi_gfID = gpo_id FROM PICO_Y_PALA.grupo_familiar WHERE gpo_titular = @afi_nro_doc
	insert into pico_y_pala.gf_afiliado
	(agf_afi_nro_doc,agf_gpo_id)
	values(@afi_nro_doc,@afi_gfID)
END
GO

CREATE PROCEDURE PICO_Y_PALA.altaAfiliadoAGrupoFamiliar (@afi_DocAfiTitular numeric(18,0) ,@afi_nroAfi numeric(18,0), @afi_username VARCHAR(50),@afi_nro_doc numeric(18,0),@afi_password varchar(64) ,@afi_nombre varchar(255),@afi_apellido varchar(255),@afi_tipo_doc varchar(3),@afi_direccion varchar(255),@afi_telefono numeric(18,0),@afi_mail varchar(255),@afi_fecha_nac datetime,@afi_sexo char(1), @afi_plan varchar(255), @afi_eci varchar (100))
AS
BEGIN
	DECLARE @afi_planID NUMERIC (18,0), @afi_eciID INT,@afi_gfID NUMERIC (18,0)
	
	IF exists (SELECT * FROM PICO_Y_PALA.usuario WHERE usu_nro_doc=@afi_nro_doc)
	BEGIN
		RAISERROR('Ya hay un usuario con el Documento Ingresado',16,1)
		RETURN
	END
	IF exists (SELECT * FROM PICO_Y_PALA.usuario WHERE usu_username=@afi_username)
	BEGIN
		RAISERROR('Ya existe el nombre de usuario ingresado',16,1)
		RETURN
	END
	IF NOT (exists (SELECT * FROM PICO_Y_PALA.afiliado WHERE afi_nro_doc = @afi_DocAfiTitular and afi_activo=1))
	BEGIN
		RAISERROR('No existe el Afiliado Titular ingresado o ha sido dado de baja',16,1)
		RETURN
	END
	SELECT @afi_planID = pla_codigo FROM PICO_Y_PALA.planes WHERE pla_desc = @afi_plan
	SELECT @afi_eciID = eci_id FROM PICO_Y_PALA.estado_civil WHERE eci_desc = @afi_eci

-- Verifico que exista un Grupo Familiar con el el Titular ingresado como titular del grupo	
	IF NOT (exists (SELECT * FROM PICO_Y_PALA.grupo_familiar WHERE gpo_titular = @afi_DocAfiTitular))
	BEGIN
		RAISERROR('El Nro de Afiliado ingresado no es titular de ningun Grupo Familiar',16,1)
		RETURN
	END

--Creo el Usuario
	insert into pico_y_pala.usuario
	(usu_username,usu_nro_doc,usu_password,usu_apellido,usu_nombre,usu_tipo_doc,usu_direccion,usu_telefono,usu_mail,usu_fecha_nac,usu_sexo,usu_habilitado,usu_intentos_fallidos)
	values (@afi_username,@afi_nro_doc,@afi_password,@afi_apellido,@afi_nombre,@afi_tipo_doc,@afi_direccion,@afi_telefono,@afi_mail,@afi_fecha_nac,@afi_sexo,1,0)
--Asigno Rol a usuario
	insert into pico_y_pala.rol_usuario
	(rus_rol_id,rus_usu_username)
	values(3,@afi_username)
--Creo el Afiliado 
	insert into pico_y_pala.afiliado
	(afi_nro_doc,afi_nro_afiliado,afi_eci_id,afi_pla_codigo,afi_nro_consulta,afi_activo,afi_fecha_baja) 
	values (@afi_nro_doc,@afi_nroAfi,@afi_eciID,@afi_planID,0,1,null)
--Asocio el Grupo Familiar con el Afiliado
	SELECT @afi_gfID = gpo_id FROM PICO_Y_PALA.grupo_familiar WHERE gpo_titular = @afi_DocAfiTitular
	
	insert into pico_y_pala.gf_afiliado
	(agf_afi_nro_doc,agf_gpo_id)
	values(@afi_nro_doc,@afi_gfID)
END
GO

CREATE PROCEDURE PICO_Y_PALA.modificarAfiliado (@afi_Doc numeric(18,0), @cambioPlan int, @afi_MotivoCambio varchar(255), @afi_planNuevo varchar(255), @afi_planViejo varchar(255),@afi_direccion varchar(255),@afi_telefono numeric(18,0),@afi_mail varchar(255))
AS
BEGIN
	DECLARE @afi_planID_Nuevo NUMERIC (18,0), @afi_planID_Viejo NUMERIC (18,0)
	SELECT @afi_planID_Nuevo = pla_codigo FROM PICO_Y_PALA.planes WHERE pla_desc = @afi_planNuevo
	SELECT @afi_planID_Viejo = pla_codigo FROM PICO_Y_PALA.planes WHERE pla_desc = @afi_planViejo
	IF (@cambioPlan = 1)
	BEGIN
		update pico_y_pala.afiliado set afi_pla_codigo = @afi_planID_Nuevo where afi_nro_doc=@afi_Doc
		update pico_y_pala.usuario set usu_direccion = @afi_direccion, usu_mail=@afi_mail, usu_telefono=@afi_telefono where usu_nro_doc=@afi_Doc
		insert into pico_y_pala.audit_cambio_plan (acp_afiliado,acp_fecha,acp_motivo,acp_plan_anterior,acp_plan_nuevo) values (@afi_Doc,GETDATE(),@afi_MotivoCambio,@afi_planID_Viejo,@afi_planID_Nuevo)
		RETURN
	END
	ELSE
	BEGIN
		update pico_y_pala.usuario set usu_direccion = @afi_direccion, usu_mail=@afi_mail, usu_telefono=@afi_telefono where usu_nro_doc=@afi_Doc
	END
END
GO

CREATE PROCEDURE PICO_Y_PALA.compraBonos (@afi_NroAfi numeric(18,0), @cantBonos int, @precioBonos int)
AS
BEGIN
DECLARE @afiNroDoc NUMERIC (18,0)
	IF NOT (exists (SELECT * FROM PICO_Y_PALA.afiliado WHERE afi_nro_afiliado = @afi_NroAfi and afi_activo=1))
	BEGIN
		RAISERROR('No se puede realizar la compra, el Afiliado no esta activo.',16,1)
		RETURN
	END
	SELECT @afiNroDoc=afi.afi_nro_doc from pico_y_pala.afiliado afi where afi.afi_nro_afiliado=@afi_NroAfi
	INSERT INTO pico_y_pala.compra (com_afi_compro,com_cant,com_fecha,com_precio)values(@afiNroDoc,@cantBonos,GETDATE(),(@cantBonos*@precioBonos))
END
GO

CREATE TRIGGER PICO_Y_PALA.trigger_agregarBonos ON pico_y_pala.compra FOR INSERT
AS
BEGIN
DECLARE @planID NUMERIC (18,0),@cantBonos NUMERIC (18,0),@precioBonos NUMERIC (18,0), @afiCompro NUMERIC (18,0), @idCompra NUMERIC (18,0)
select @idCompra=ins.com_id,@afiCompro=ins.com_afi_compro, @cantBonos=ins.com_cant,@precioBonos=(ins.com_precio/ins.com_cant) from inserted ins
select @planID=pla.pla_codigo from pico_y_pala.planes pla where pla.pla_precio_consulta=@precioBonos
DECLARE @i int
SET @i =1

WHILE @i <= @cantBonos  
	BEGIN  
	INSERT INTO pico_y_pala.bono (bon_afiliado_compra,bon_com_id,bon_pla_id) values(@afiCompro,@idCompra,@planID)
	set @i= @i+1
	END 
END
GO