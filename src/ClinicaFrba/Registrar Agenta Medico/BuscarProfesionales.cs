﻿using ClinicaFrba.Abm_Profesional;
using ClinicaFrba.BaseDeDatos;
using ClinicaFrba.BaseDeDatos.Componentes;
using ClinicaFrba.Validaciones;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClinicaFrba.Registrar_Agenta_Medico
{
    public partial class BuscarProfesionales : Form
    {
        private DataSet pagingDS;
        private int scrollVal;
        private int cantProfesionales;
        private int nroPagina;
        private int cantPaginas;
        private StringBuilder sql = new StringBuilder();
        private StringBuilder sqlCount = new StringBuilder();
        private StringBuilder sqlWhere = new StringBuilder("");
        private static readonly int CANT_POR_PAGINA = int.Parse(ConfigurationManager.AppSettings["valor.paginacion"]);
        public Profesional ProfesionalReturn { get; set; }

        public BuscarProfesionales()
        {
            InitializeComponent();
        }

        private void btn_buscar_Click(object sender, EventArgs e)
        {
            try
            {
                this.lbl_error_nro_matricula.Visible = false;
                this.lbl_error_nro_doc.Visible = false;
                ManipulacionComponentes.vaciarGrid(this.dgv_profesionales);
                ManipulacionComponentes.deshabilitarComponentes(new List<Control>(){this.btn_primera,this.btn_anterior,this.btn_siguiente,this.btn_ultima,
                                                                              this.btn_seleccionar});
                this.lbl_nro_pagina.Text = "";
                this.lbl_nro_profesionales.Text = "";

                if (validar())
                {
                    ManipulacionComponentes.habilitarComponentes(new List<Control>(){this.btn_primera,this.btn_anterior,this.btn_siguiente,this.btn_ultima,
                                                                              this.btn_seleccionar});
                    armarQuery();
                    pagingDS = new DataSet();
                    ManipulacionComponentes.llenarGrid(dgv_profesionales, sql.ToString(), pagingDS, scrollVal, CANT_POR_PAGINA, "Profesionales");
                    dgv_profesionales.DataSource = pagingDS;
                    dgv_profesionales.DataMember = "Profesionales";
                    cantProfesionales = calcularFilasTotal();
                    lbl_nro_profesionales.Text = cantProfesionales.ToString();
                    if (cantProfesionales == 0)
                    {
                        cantPaginas = 1;
                        ManipulacionComponentes.deshabilitarComponentes(new List<Control>(){this.btn_primera,this.btn_anterior,this.btn_siguiente,this.btn_ultima,
                                                                              this.btn_seleccionar});
                    }
                    else
                    {
                        cantPaginas = cantProfesionales / CANT_POR_PAGINA;
                    }
                    nroPagina = 1;
                    if (cantProfesionales % CANT_POR_PAGINA > 0)
                    {
                        cantPaginas = cantPaginas + 1;
                    }
                    lbl_nro_pagina.Text = "Página " + nroPagina + " de " + cantPaginas;
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                MessageBox.Show("Se ha producido un error al buscar profesionales: " + ex.Message, "Error inesperado", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }

        private bool validar()
        {
            bool validacion = true;
            if (!ValidacionComponentes.validarNumericoPositivo(this.txt_matricula) && ValidacionComponentes.textBoxLlenoCampo(this.txt_matricula))
            {
                this.lbl_error_nro_matricula.Visible = true;
                validacion = false;
            }
            if (!ValidacionComponentes.validarNumericoPositivo(this.txt_nro_documento) && ValidacionComponentes.textBoxLlenoCampo(this.txt_nro_documento))
            {
                this.lbl_error_nro_doc.Visible = true;
                validacion = false;
            }
            return validacion;
        }

        private void armarQuery()
        {
            sql.Clear();
            sqlCount.Clear();
            sql.Append(ConfigurationManager.AppSettings["query.obtener.profesionales.select"]);
            sqlCount.Append(ConfigurationManager.AppSettings["query.obtener.profesionales.count"]);
            //Armamos el where
            sqlWhere.Clear();
            sqlWhere.Append(" WHERE");
            sqlWhere.Append(ConfigurationManager.AppSettings["query.obtener.profesionales.where.apellido"].Replace("{0}", this.txt_apellido.Text));
            sqlWhere.Append(" AND").Append(ConfigurationManager.AppSettings["query.obtener.profesionales.where.nombre"].Replace("{1}", this.txt_nombre.Text));
            if (ValidacionComponentes.textBoxLlenoCampo(this.txt_nro_documento))
            {
                sqlWhere.Append(" AND").Append(ConfigurationManager.AppSettings["query.obtener.profesionales.where.nro.doc"].Replace("{2}", this.txt_nro_documento.Text));
            }
            if (ValidacionComponentes.textBoxLlenoCampo(this.txt_matricula))
            {
                sqlWhere.Append(" AND").Append(ConfigurationManager.AppSettings["query.obtener.profesionales.where.matricula"].Replace("{3}", this.txt_matricula.Text));
            }
            if (ValidacionComponentes.textBoxLlenoCampo(this.txt_especialidad))
            {
                sqlWhere.Append(" AND").Append(ConfigurationManager.AppSettings["query.obtener.profesionales.where.especialidad"].Replace("{4}", this.txt_especialidad.Text));
            }

            sql.Append(sqlWhere);
            sqlCount.Append(sqlWhere);
            sql.Append(ConfigurationManager.AppSettings["query.obtener.profesionales.group.by"]);
        }

        private void btn_limpiar_Click(object sender, EventArgs e)
        {
            this.txt_nombre.Text = "";
            this.txt_apellido.Text = "";
            this.txt_especialidad.Text = "";
            this.txt_nro_documento.Text = "";
            this.txt_matricula.Text = "";
            ManipulacionComponentes.vaciarGrid(this.dgv_profesionales);
            this.lbl_nro_pagina.Text = "";
            this.lbl_nro_profesionales.Text = "";
            ManipulacionComponentes.deshabilitarComponentes(new List<Control>(){this.btn_primera,this.btn_anterior,this.btn_siguiente,this.btn_ultima,
                                                                              this.btn_seleccionar});
        }

        private void btn_primera_Click(object sender, EventArgs e)
        {
            try
            {
                scrollVal = 0;
                nroPagina = 1;
                ManipulacionComponentes.llenarGrid(dgv_profesionales, sql.ToString(), pagingDS, scrollVal, CANT_POR_PAGINA, "Profesionales");
                lbl_nro_pagina.Text = "Página " + nroPagina + " de " + cantPaginas;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                MessageBox.Show("Error al procesar la solicitud: " + ex.Message, "Error inesperado", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }

        private void btn_anterior_Click(object sender, EventArgs e)
        {
            try
            {
                scrollVal = scrollVal - CANT_POR_PAGINA;
                if (scrollVal <= 0)
                {
                    scrollVal = 0;
                    nroPagina = 1;
                }
                else
                {
                    --nroPagina;
                }
                ManipulacionComponentes.llenarGrid(dgv_profesionales, sql.ToString(), pagingDS, scrollVal, CANT_POR_PAGINA, "Profesionales");
                lbl_nro_pagina.Text = "Página " + nroPagina + " de " + cantPaginas;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                MessageBox.Show("Error al procesar la solicitud: " + ex.Message, "Error inesperado", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }

        private void btn_siguiente_Click(object sender, EventArgs e)
        {
            try
            {
                scrollVal = scrollVal + CANT_POR_PAGINA;
                if (scrollVal > cantProfesionales)
                {
                    scrollVal = scrollVal - CANT_POR_PAGINA;
                }
                else
                {
                    lbl_nro_pagina.Text = "Página " + ++nroPagina + " de " + cantPaginas;
                }
                ManipulacionComponentes.llenarGrid(dgv_profesionales, sql.ToString(), pagingDS, scrollVal, CANT_POR_PAGINA, "Profesionales");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                MessageBox.Show("Error al procesar la solicitud: " + ex.Message, "Error inesperado", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }

        private void btn_ultima_Click(object sender, EventArgs e)
        {
            try
            {
                scrollVal = cantProfesionales / CANT_POR_PAGINA;
                if (cantProfesionales % CANT_POR_PAGINA > 0)
                {
                    /*Para que muestre realmente los registros que entrarían en la última página como si hiciésemos "Siguiente"
                     * hasta el final
                     */
                    scrollVal = cantProfesionales - (cantProfesionales % CANT_POR_PAGINA);

                }
                else
                {
                    scrollVal = cantProfesionales - CANT_POR_PAGINA;
                }
                ManipulacionComponentes.llenarGrid(dgv_profesionales, sql.ToString(), pagingDS, scrollVal, CANT_POR_PAGINA, "Profesionales");
                nroPagina = cantPaginas;
                lbl_nro_pagina.Text = "Página " + nroPagina + " de " + cantPaginas;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                MessageBox.Show("Error al procesar la solicitud: " + ex.Message, "Error inesperado", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }

        private void BuscarProfesionales_Load(object sender, EventArgs e)
        {
            try
            {
                ManipulacionComponentes.deshabilitarComponentes(new List<Control>(){this.btn_primera,this.btn_anterior,this.btn_siguiente,this.btn_ultima,
                                                                              this.btn_seleccionar});
                this.lbl_error_nro_doc.Visible = false;
                this.lbl_error_nro_matricula.Visible = false;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                MessageBox.Show("Se ha producido un error al cargar la pantalla: " + ex.Message, "Error inesperado", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }

        private void btn_seleccionar_Click(object sender, EventArgs e)
        {
            if (this.dgv_profesionales.DisplayedRowCount(true) == 0)
            {
                MessageBox.Show("Seleccione un profesional de la lista", "Error de validación", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
            else
            {
                this.ProfesionalReturn = new Profesional(this.dgv_profesionales.SelectedRows[0].Cells[0].Value.ToString(),
                                                         this.dgv_profesionales.SelectedRows[0].Cells[1].Value.ToString(),
                                                         this.dgv_profesionales.SelectedRows[0].Cells[2].Value.ToString(),
                                                         Convert.ToInt32(this.dgv_profesionales.SelectedRows[0].Cells[3].Value),
                                                         Convert.ToInt32(this.dgv_profesionales.SelectedRows[0].Cells[4].Value));
                this.DialogResult = DialogResult.OK;
                this.Close();

            }
        }

        private void btn_atras_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }

        private int calcularFilasTotal()
        {
            using (SqlConnection cx = Connection.getConnection())
            {
                try
                {
                    SqlCommand sqlCmd = new SqlCommand(sqlCount.ToString(), cx);
                    cx.Open();
                    SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                    sqlReader.Read();
                    return Int32.Parse(sqlReader["total_profesionales"].ToString());

                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                    throw ex;
                }
            }
        }
    }
}
