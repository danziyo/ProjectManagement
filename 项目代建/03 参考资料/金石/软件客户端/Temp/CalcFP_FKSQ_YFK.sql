CREATE PROCEDURE  [dbo].[CalcFP_FKSQ_YFK]  
@DYDJ varchar(20) ,
@DJLX varchar(20) ,
@FPBH varchar(500) output,
@FPJE Float output,
@YSQJE Float output,
@YFKJE Float output, 
@DKJE Float output
AS 
  declare @CurFPBH varchar(100) 
  declare @CurFPJE Float 
  declare @Sql_Str Varchar(255)
  Set @FPJE=0
  Set @FPBH='' 

  Set @Sql_Str='Declare cur1 Cursor Global  For Select Sum(��Ӧ���) As DYJE ,��Ʊ��� As FPBH From ��Ʊ�ӱ� where ��Ʊ��Ӧ����='''+@DYDJ+''' And ����=0 Group By ��Ʊ���';
  Exec(@Sql_Str)
  Open cur1
  Fetch Next From cur1 into @CurFPJE,@CurFPBH
  While (@@Fetch_Status=0)
  Begin
    IF @FPBH<>''
    Begin
       Set @FPBH=@FPBH+','
    End
    Set @FPBH=@FPBH+@CurFPBH 
    Set @FPJE=@FPJE+@CurFPJE
    Fetch Next From cur1 into @CurFPJE,@CurFPBH
  End

  Close cur1
  deallocate cur1
 
  Set @Sql_Str='Declare cur2 Cursor Global For Select Sum(���) As FKJE From ����������ϸ�� where ���������='''+@DJLX+''' And �����Ӧ����='''+@DYDJ+''' And ����=0';
  Exec(@Sql_Str)
  Open cur2
  Fetch Next From cur2 into @YSQJE
  Close cur2
  deallocate cur2

  Set @Sql_Str='Declare cur3 Cursor Global For Select Sum(���) As FKJE From �ո�����ϸ�� where ���������='''+@DJLX+''' And �����Ӧ����='''+@DYDJ+''' And ����=0';
  Exec(@Sql_Str)
  Open cur3
  Fetch Next From cur3 into @YFKJE
  Close cur3
  deallocate cur3

  Set @DKJE=0
  IF @DJLX='���ϲɹ���' 
  Begin
    Set @Sql_Str='Declare cur4 Cursor Global For Select Sum(�ֿ۲ɹ����) As DKJE From �������˱� where ��������=''�����˻���'' And ����=0 And �ֿ۲ɹ�����='''+@DYDJ+'''';
    Exec(@Sql_Str)
    Open cur4
    Fetch Next From cur4 into @DKJE
    Close cur4
    deallocate cur4
  End 