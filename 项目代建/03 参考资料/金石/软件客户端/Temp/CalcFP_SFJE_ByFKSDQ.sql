Create PROCEDURE  [dbo].[CalcFP_SFJE_ByFKSDQ]
@DYDJ Varchar(20) , 
@FPBH varchar(500) output,
@FPJE Float output,
@ShiFuJE Float(20) output
AS
BEGIN 
  declare @CurFPBH varchar(100) 
  declare @CurFPJE Float 
  declare @Sql_Str Varchar(255)
  Set @FPJE=0
  Set @FPBH='' 
  Set @ShiFuJE=0

  Set @Sql_Str='Declare cur1 Cursor Global For Select Sum(��Ӧ���) As DYJE ,��Ʊ��� As FPBH From ��Ʊ�ӱ� where ����=0 And ��Ʊ��Ӧ���� In (Select �����Ӧ���� From ����������ϸ�� where ��Ӧ���� = '''+@DYDJ +''' And ����=0 ) Group By ��Ʊ���';
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
    
  Set @Sql_Str='Declare cur2 Cursor Global For Select Sum(���) As Ljje  From �ո�����ϸ�� where MainID In (Select AutoID From �ո������˱� where ���뵥��='''+@DYDJ+''' And ����=0)';
  Exec(@Sql_Str)
  Open cur2
  Fetch Next From cur2 into @ShiFuJE  
  Close cur2
  deallocate cur2
 
END
